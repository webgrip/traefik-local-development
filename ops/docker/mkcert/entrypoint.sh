#!/bin/sh
if [ ! -f /root/.local/share/mkcert/rootCA.pem ]; then
    mkcert -install
fi

export CAROOT=/root/.local/share/mkcert

mkcert -cert-file /certitificate-data/cert.pem -key-file /certitificate-data/key.pem "*.test" "traefik.test" "*.traefik.test"

#Keep running
tail -f /dev/null