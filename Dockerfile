# Ref: https://github.com/prometheus/prometheus/blob/main/Dockerfile
# Prometheus version - 2.28.1
ARG ARCH="amd64"
ARG OS="linux"
FROM quay.io/prometheus/busybox-${OS}-${ARCH}:latest

COPY prometheus /bin/prometheus
COPY promtool /bin/promtool
COPY prometheus.yml /etc/prometheus/prometheus.yml
COPY console_libraries/ /usr/share/prometheus/console_libraries/
COPY consoles/ /usr/share/prometheus/consoles/

# May remove later
COPY LICENSE /LICENSE
COPY NOTICE /NOTICE
# COPY npm_licenses.tar.bz2                   /npm_licenses.tar.bz2

RUN ln -s /usr/share/prometheus/console_libraries /usr/share/prometheus/consoles/ /etc/prometheus/
RUN mkdir -p /prometheus && \
    chown -R nobody:nobody etc/prometheus /prometheus

USER       nobody
EXPOSE     9090
VOLUME     [ "/prometheus" ]
WORKDIR    /prometheus
ENTRYPOINT [ "/bin/prometheus" ]
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
             "--storage.tsdb.path=/prometheus", \
             "--web.console.libraries=/usr/share/prometheus/console_libraries", \
             "--web.console.templates=/usr/share/prometheus/consoles" ]

