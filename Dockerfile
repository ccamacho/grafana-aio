#FROM grafana/grafana:10.2.3-ubuntu
FROM grafana/grafana:latest-ubuntu

### Begin running all the preparation tasks
USER root
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y git jq wget nano python3 python3-pip build-essential tar curl zip unzip pkg-config
# Influxdb, supervisord, and cron steps
RUN apt-get install -y supervisor && \
    apt-get install -y cron
# We need the latest InfluxDB 2 available
RUN wget -q https://repos.influxdata.com/influxdata-archive_compat.key && \
    echo 'deb [allow-insecure=yes trusted=yes] https://repos.influxdata.com/debian stable main' | tee /etc/apt/sources.list.d/influxdata.list  && \
    apt-get update -y && apt-get install -y influxdb2
# Install grabana
RUN mkdir grabana_release && \
    wget -q https://github.com/K-Phoen/grabana/releases/download/v0.22.1/grabana_0.22.1_linux_amd64.tar.gz && \
    tar -zxvf grabana_0.22.1_linux_amd64.tar.gz -C grabana_release && \
    mv grabana_release/grabana /usr/local/bin/ && \
    chmod +x /usr/local/bin/grabana
# Install latest jsonnet
RUN git clone https://github.com/google/jsonnet.git jsonnet-sources && \
    cd jsonnet-sources && \
    make && \
    mv jsonnet /usr/local/bin/jsonnet
#jsonnet bundler
RUN curl -L https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v0.5.1/jb-linux-amd64 -o /usr/local/bin/jb && \
    chmod +x /usr/local/bin/jb
RUN jb --version
RUN mkdir -p /var/log/supervisor
# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN echo 'root:root' | chpasswd
# User
ARG USER=psap
ARG UID=1001
ARG HOME=/home/$USER
RUN echo "==> Creating local user account..."  && \
    useradd --create-home --uid $UID --gid 0 $USER && \
    ln -s $HOME/$USER/ /$USER
WORKDIR $HOME
RUN chown -R ${USER}:0 $HOME
# Allow processes started from the base user (psap)
# to access /var/lib and /var/run files, /var/run
# is a symlink so /run it also needs to be updated
RUN chown -R ${USER}:0 /var/lib
RUN chown -R ${USER}:0 /var/run
RUN chown -R ${USER}:0 /run
RUN chmod gu+rw /var/run
RUN chmod gu+s /usr/sbin/cron
# We go back to a non privileged execution
USER $USER
RUN mkdir -p /home/$USER/supervisord
ENV PATH $HOME/.local/bin:$PATH
COPY --chown=${USER}:0 . .
RUN echo "==> Adding Python dependencies..." && \
    python3 -m pip install --user --upgrade pip && \
    python3 -m pip install --user --upgrade wheel && \
    python3 -m pip install --user --upgrade shyaml netaddr ipython dnspython && \
    python3 -m pip install --user -r requirements.txt
# OpenSearch
RUN mkdir -p /home/psap/opensearch && \
    curl -SL https://artifacts.opensearch.org/releases/bundle/opensearch/2.11.1/opensearch-2.11.1-linux-x64.tar.gz | tar -zxC /home/psap/opensearch && \
    rm -rf /home/psap/opensearch/opensearch-2.11.1/plugins/opensearch-security

COPY config/opensearch.yml /home/psap/opensearch/opensearch-2.11.1/config/opensearch.yml
# Run the workarounds script
RUN ./scripts/extra_steps.sh
# Here we install both versions of grafonnet
# (the old grafonnet-lib and the new grafonnet)
RUN cd jsonnet_deps  && \
    jb install
#RUN cd jsonnet_deps/vendor && \
#    git clone https://github.com/grafana/jsonnet-libs.git
### End running all the preparation tasks

### Begin copying the custom provisioning configuration files into the container
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/grafana.ini /etc/grafana/grafana.ini
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
RUN find /etc/grafana/provisioning/dashboards \
    -type f \
    -name "*.dashboard.py" \
    -exec sh \
    -c 'output_file="${0%.py}.json"; generate-dashboard -o "$output_file" "{}"' {} \;
RUN find /etc/grafana/provisioning/dashboards \
    -type f \
    -name "*.dashboard.jsonnet" \
    -exec sh -c 'input_file="{}"; output_file="${input_file%.jsonnet}.json"; jsonnet -J ~/jsonnet_deps/vendor "$input_file" -o "$output_file"' \;
RUN find /etc/grafana/provisioning/dashboards \
    -type f \
    -name "*.dashboard.yml" \
    -exec sh -c 'input_file="{}"; output_file="${input_file%.yml}.json"; grabana render --input="$input_file" > "$output_file"' \;
### End configuring the dashboards

### Begin install additional plugins
# All used plugins must be installed first
# than using them in the provision scripts
RUN grafana cli plugins install grafana-clock-panel && \
    grafana cli plugins install grafana-piechart-panel && \
    grafana cli plugins install grafana-opensearch-datasource
### End installing additional plugins

# Make sure cron is installed
RUN crontab $HOME/config/cron.conf
# Expose the Grafana port
EXPOSE 3000

# We enable the cron execution and we start supervisord
ENTRYPOINT ["sh", "-c", "cron && /usr/bin/supervisord"]
