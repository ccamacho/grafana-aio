# Stable release
# FROM grafana/grafana:10.2.3-ubuntu
# Latest release
FROM grafana/grafana:latest-ubuntu
# Latest main
# FROM grafana/grafana:main-ubuntu

### Begin running all the preparation tasks
USER root

### Create a new user
# User creation
ARG USER=grafana-aio
ARG UID=1001
ARG HOME=/home/$USER
RUN echo "==> Creating local user account..." && \
    useradd --create-home --uid $UID --group root $USER
# Reset passwords
RUN echo "$USER:$USER" | chpasswd
RUN echo 'root:root' | chpasswd
WORKDIR $HOME

### Moving deps install here
COPY requirements.txt .
COPY scripts/install_dependencies.sh scripts/install_dependencies.sh
COPY jsonnet_deps /opt/jsonnet_deps
RUN ./scripts/install_dependencies.sh
### End of moving deps intall here
# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

### Set up folders permissions
RUN mkdir -p /var/supervisor && \
    mkdir -p /var/log/supervisor && \
    touch /var/log/supervisor/supervisord.log && \
    touch /var/supervisor/supervisord.pid && \
    touch /var/supervisor/supervisord.sock && \
    chmod -R guo+rw /var/supervisor/ && \
    chmod -R guo+rw /var/log/supervisor/

# Allow processes started from the base user
# to access files
RUN chgrp -R 0 /var
RUN chgrp -R 0 /run
RUN chgrp -R 0 /opt
RUN chgrp -R 0 /etc

RUN chown -R ${USER}:0 /var
RUN chown -R ${USER}:0 /run
RUN chown -R ${USER}:0 /opt
RUN chown -R ${USER}:0 /etc

RUN chmod guo+rw /var
RUN chmod guo+rw /run
RUN chmod guo+rw /opt
RUN chmod guo+rw /etc

RUN chmod gu+s /usr/sbin/cron

### Begin copying the custom provisioning configuration files into the container
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/grafana.ini /etc/grafana/grafana.ini
COPY config/prometheus.yml /etc/prometheus/prometheus.yml
COPY config/opensearch.yml /opt/opensearch/config/opensearch.yml
COPY config/opensearch_dashboards.yml /opt/opensearch-dashboards/config/opensearch_dashboards.yml
COPY provisioning/datasources/datasources.yml /etc/grafana/provisioning/datasources/datasources.yml
COPY provisioning/plugins/plugins.yml /etc/grafana/provisioning/plugins/plugins.yml
### End copying the custom provisioning configuration files into the container

### Begin configuring the dashboards
# We copy first the file structure used to hierarchical store the dashboards in the corresponding folders
COPY provisioning/dashboards/ /etc/grafana/provisioning/dashboards/
# We copy all the file structure from the custom_dashboards folder
# This will preserve the Grafana folders to store all the dashboards
COPY custom_dashboards /etc/grafana/provisioning/dashboards/
# We copy the rest of the scripts
COPY scripts scripts
# Render all the dashboards from the final file structure in /etc/grafana/provisioning/dashboards/
# The command will find all the python files and render the json dashboard files in the same folder
# grafanalib dashboards
RUN find /etc/grafana/provisioning/dashboards \
    -type f \
    -name "*.dashboard.py" \
    -exec sh \
    -c 'output_file="${0%.py}.json"; generate-dashboard -o "$output_file" "{}"' {} \;
# grafonnet and grafonnet-lib dashobards
RUN find /etc/grafana/provisioning/dashboards \
    -type f \
    -name "*.dashboard.jsonnet" \
    -exec sh -c 'input_file="{}"; output_file="${input_file%.jsonnet}.json"; jsonnet -J /opt/jsonnet_deps/vendor "$input_file" -o "$output_file"' \;
# grabana dashboards
RUN find /etc/grafana/provisioning/dashboards \
    -type f \
    -name "*.dashboard.yml" \
    -exec sh -c 'input_file="{}"; output_file="${input_file%.yml}.json"; grabana render --input="$input_file" | tee "$output_file" > /dev/null' \;
### End configuring the dashboards

# We copy the entrypoint script
COPY scripts/entrypoint.sh /usr/bin/

USER $USER
# Make sure cron is installed
# RUN crontab $HOME/config/cron.conf
# Expose the Grafana port

# We enable the cron execution and we start supervisord
# ENTRYPOINT ["sh", "-c", "cron && /usr/bin/supervisord"]
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
