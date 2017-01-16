FROM debian:jessie
MAINTAINER Andy Taylor andy@andy.com

ENV \
  GRAFANA_VERSION=latest \
  PLUGIN_DIR=/grafana-plugins \
  UPGRADEALL=true

COPY ./go.sh /go.sh

RUN \
  apt-get update && \
  apt-get -y --force-yes --no-install-recommends install libfontconfig curl ca-certificates git jq && \
  curl https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb > /tmp/grafana.deb && \
  dpkg -i /tmp/grafana.deb && \
  rm -f /tmp/grafana.deb && \
  curl -L https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 > /usr/sbin/gosu && \
  chmod +x /usr/sbin/gosu && \
  for plugin in $(curl -s https://grafana.net/api/plugins?orderBy=name | jq '.items[] | select(.internal=='false') | .slug' | tr -d '"'); do grafana-cli --pluginsDir "${GF_PLUGIN_DIR}" plugins install $plugin; done && \
  chmod +x /go.sh && \
  apt-get remove -y --force-yes curl git jq && \
  apt-get autoremove -y --force-yes && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*  

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3000

ENTRYPOINT ["/go.sh"]
