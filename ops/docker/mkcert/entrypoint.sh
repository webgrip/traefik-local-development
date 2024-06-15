#!/bin/sh
if [ ! -f /root/.local/share/mkcert/rootCA.pem ]; then
    mkcert -install
    chmod 777 /root/.local/share/mkcert/rootCA.pem
    chmod 777 /root/.local/share/mkcert/rootCA-key.pem
fi

mkcert -cert-file /certitificate-data/cert.pem -key-file /certitificate-data/key.pem "*.test" "traefik.test" "*.traefik.test"

# build ssl.yml

# Signal that the service is healthy
touch /certitificate-data/healthy

#Keep running
tail -f /dev/null