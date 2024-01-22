# Stable release
# FROM grafana/grafana:10.2.3-ubuntu
# Latest release
FROM grafana/grafana:latest-ubuntu
# Latest main
# FROM grafana/grafana:main-ubuntu

### Begin running all the preparation tasks
USER root

### Moving deps intall here
COPY requirements.txt .
COPY scripts/install_dependencies.sh scripts/install_dependencies.sh
RUN ./scripts/install_dependencies.sh
### End of moving deps intall here

# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

### Create a new user
# User creation
ARG USER=psap
ARG UID=1001
ARG HOME=/home/$USER
RUN echo "==> Creating local user account..." && \
    useradd --create-home --uid $UID --gid 0 $USER && \
    ln -s $HOME/$USER/ /$USER
RUN adduser $USER sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# Reset passwords
RUN echo "$USER:$USER" | chpasswd
RUN echo 'root:root' | chpasswd
# Run all the comands from the new user home folder
WORKDIR $HOME

### Install additional software
# Install grabana
# This is a binary so we need to create a folder to store it first
RUN mkdir grabana && \
    curl -SL https://github.com/K-Phoen/grabana/releases/download/v0.22.1/grabana_0.22.1_linux_amd64.tar.gz | tar -zxC grabana && \
    mv grabana/grabana /usr/local/bin/ && \
    chmod +x /usr/local/bin/grabana
# Install latest jsonnet
RUN git clone https://github.com/google/jsonnet.git jsonnet-sources && \
    cd jsonnet-sources && \
    make && \
    mv jsonnet /usr/local/bin/jsonnet && \
    chmod +x /usr/local/bin/jsonnet
# Install jsonnet bundler
RUN curl -SL https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v0.5.1/jb-linux-amd64 -o /usr/local/bin/jb && \
    chmod +x /usr/local/bin/jb
RUN jb --version
# Here we install both versions of grafonnet
# (the old grafonnet-lib and the new grafonnet)
COPY jsonnet_deps jsonnet_deps
RUN cd jsonnet_deps  && \
    jb install
# Install Prometheus
RUN mkdir /etc/prometheus && \
    mkdir /var/lib/prometheus && \
    curl -SL https://github.com/prometheus/prometheus/releases/download/v2.48.1/prometheus-2.48.1.linux-amd64.tar.gz | tar -zx && \
    cd prometheus-2.48.1.linux-amd64 && \
    mv prometheus /usr/local/bin && \
    mv promtool /usr/local/bin && \
    chown -R ${USER}:0 /usr/local/bin/prometheus && \
    chown -R ${USER}:0 /usr/local/bin/promtool && \
    mv consoles /etc/prometheus && \
    mv console_libraries /etc/prometheus && \
    mv prometheus.yml /etc/prometheus && \
    chown -R ${USER}:0 /etc/prometheus && \
    chown -R ${USER}:0 /etc/prometheus/consoles && \
    chown -R ${USER}:0 /etc/prometheus/console_libraries && \
    chown -R ${USER}:0 /var/lib/prometheus
# Install OpenSearch
# Faster downloads from GitHub
# https://github.com/opensearch-project/OpenSearch/archive/refs/tags/2.11.1.tar.gz
# All the security plugins are removed from the initial installation
# Make sure to check the extracted OpenSearch folder name OpenSearch != opensearch
# Depending if the download is from github or opensearch the folders have different names...
ARG OPENSEARCH_VERSION="2.11.1"
RUN curl -SL https://artifacts.opensearch.org/releases/bundle/opensearch/2.11.1/opensearch-2.11.1-linux-x64.tar.gz | tar -zx && \
    ./opensearch-2.11.1/bin/opensearch-plugin install https://github.com/Aiven-Open/prometheus-exporter-plugin-for-opensearch/releases/download/2.11.1.0/prometheus-exporter-2.11.1.0.zip && \
    rm -rf ./opensearch-2.11.1/plugins/opensearch-security

RUN curl -SL https://artifacts.opensearch.org/releases/bundle/opensearch-dashboards/2.11.1/opensearch-dashboards-2.11.1-linux-x64.tar.gz | tar -zx && \
    ./opensearch-dashboards-2.11.1/bin/opensearch-dashboards-plugin remove securityDashboards --allow-root

### Begin install additional GRafana plugins
# All used plugins must be installed first
# than using them in the provision scripts
RUN grafana cli plugins install nline-plotlyjs-panel && \
    grafana cli plugins install grafana-opensearch-datasource
### End installing additional plugins

### Set up folders permissions
# Allow processes started from the base user (psap)
# to access /var/lib and /var/run files, /var/run
# is a symlink so /run it also needs to be updated
RUN chown -R ${USER}:0 $HOME
RUN chown -R ${USER}:0 /var/lib
RUN chown -R ${USER}:0 /var/run
RUN chown -R ${USER}:0 /run
RUN chmod gu+rw /var/run
RUN chmod gu+s /usr/sbin/cron

### We go back to a non Privileged execution
USER $USER
RUN mkdir -p $HOME/supervisord
ENV PATH $HOME/.local/bin:$PATH
COPY --chown=${USER}:0 . .

### Begin copying the custom provisioning configuration files into the container
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/grafana.ini /etc/grafana/grafana.ini
COPY config/prometheus.yml /etc/prometheus/prometheus.yml
COPY config/opensearch.yml $HOME/opensearch-2.11.1/config/opensearch.yml
COPY config/opensearch_dashboards.yml $HOME/opensearch-dashboards-2.11.1/config/opensearch_dashboards.yml
COPY provisioning/datasources/datasources.yml /etc/grafana/provisioning/datasources/datasources.yml
COPY provisioning/plugins/plugins.yml /etc/grafana/provisioning/plugins/plugins.yml
### End copying the custom provisioning configuration files into the container

### Begin configuring the dashboards
# We copy first the file structure used to hierarchical store the dashboards in the corresponding folders
COPY provisioning/dashboards/ /etc/grafana/provisioning/dashboards/
# We copy all the file structure from the custom_dashboards folder
# This will preserve the Grafana folders to store all the dashboards
COPY custom_dashboards /etc/grafana/provisioning/dashboards/
# Render all the dashboards from the final file structure in /etc/grafana/provisioning/dashboards/
# The command will find all the python files and render the json dashboard files in the same folder
# grafanalib dashboards
RUN find /etc/grafana/provisioning/dashboards \
    -type f \
    -name "*.dashboard.py" \
    -exec sh \
    -c 'output_file="${0%.py}.json"; sudo generate-dashboard -o "$output_file" "{}"' {} \;
# grafonnet and grafonnet-lib dashobards
RUN find /etc/grafana/provisioning/dashboards \
    -type f \
    -name "*.dashboard.jsonnet" \
    -exec sh -c 'input_file="{}"; output_file="${input_file%.jsonnet}.json"; sudo jsonnet -J ~/jsonnet_deps/vendor "$input_file" -o "$output_file"' \;
# grabana dashboards
RUN find /etc/grafana/provisioning/dashboards \
    -type f \
    -name "*.dashboard.yml" \
    -exec sh -c 'input_file="{}"; output_file="${input_file%.yml}.json"; grabana render --input="$input_file" | sudo tee "$output_file" > /dev/null' \;
### End configuring the dashboards

# Make sure cron is installed
RUN crontab $HOME/config/cron.conf
# Expose the Grafana port
EXPOSE 3000

# We enable the cron execution and we start supervisord
ENTRYPOINT ["sh", "-c", "cron; /usr/bin/supervisord"]
