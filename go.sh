#!/bin/bash

chown -R grafana:grafana /var/lib/grafana /var/log/grafana

# upgrade all installed plugins
if [ "$UPGRADEALL" = true ] ; then
    grafana-cli --pluginsDir "${GF_PLUGIN_DIR}" plugins upgrade-all || true
fi

exec gosu grafana /usr/sbin/grafana-server \
  --homepath=/usr/share/grafana            \
  --config=/etc/grafana/grafana.ini        \
  cfg:default.paths.data=/var/lib/grafana  \
  cfg:default.paths.logs=/var/log/grafana  \
  cfg:default.paths.plugins=${GF_PLUGIN_DIR}

