#!/bin/sh

# Remove the health check file
rm -f /certificate-data/healthy

if [ ! -f /root/.local/share/mkcert/rootCA.pem ]; then
    mkcert -install
    chmod 777 /root/.local/share/mkcert/rootCA.pem
    chmod 777 /root/.local/share/mkcert/rootCA-key.pem
fi

# Create an empty ssl.yml if it doesn't exist or it's empty
if [ ! -s /certificate-data/ssl.yml ]; then
    echo "tls:" > /certificate-data/ssl.yml
    echo "  certificates:" >> /certificate-data/ssl.yml
fi

for domain in "$@"; do
  if [ ! -f /certificate-data/${domain}.crt ] || [ ! -f /certificate-data/${domain}.key ]; then
    echo "Generating certificate for ${domain}"
    mkcert -cert-file /certificate-data/${domain}.crt -key-file /certificate-data/${domain}.key "${domain}"
  fi

  if [ ! -f /certificate-data/${domain}.crt ] || [ ! -f /certificate-data/${domain}.key ]; then
      echo "Failed to generate certificate for ${domain}"
      exit 1
  fi

  yq eval -i ".tls.certificates += [{\"certFile\": \"/etc/traefik/dynamic/${domain}.crt\", \"keyFile\": \"/etc/traefik/dynamic/${domain}.key\"}]" /certificate-data/ssl.yml

  if ! yq eval '.tls.certificates' /certificate-data/ssl.yml > /dev/null; then
    echo "Failed to update ssl.yml with the certificate for ${domain}"
    exit 1
  fi
done

# Signal that the service is healthy
touch /certificate-data/healthy

#Keep running
tail -f /dev/null