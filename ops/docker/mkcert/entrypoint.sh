#!/bin/sh

# Define the domains here
DOMAINS="$@"

# Remove the health check file
rm -f /certificate-data/healthy

# Ensure mkcert is installed and the root CA is in place
if [ ! -f /root/.local/share/mkcert/rootCA.pem ]; then
    mkcert -install || true
    chmod 777 /root/.local/share/mkcert/rootCA.pem
    chmod 777 /root/.local/share/mkcert/rootCA-key.pem
fi

export CAROOT=/root/.local/share/mkcert

# Create an empty ssl.yml if it doesn't exist or it's empty
if [ ! -s /certificate-data/ssl.yml ]; then
    echo "tls:" > /certificate-data/ssl.yml
    echo "  certificates:" >> /certificate-data/ssl.yml
fi

for domain in $DOMAINS; do
  if [ ! -f /certificate-data/${domain}.crt ] || [ ! -f /certificate-data/${domain}.key ]; then
    echo "Generating certificate for ${domain}"
    mkcert -cert-file /certificate-data/${domain}.crt -key-file /certificate-data/${domain}.key "${domain}"
  fi

  if [ ! -f /certificate-data/${domain}.crt ] || [ ! -f /certificate-data/${domain}.key ]; then
    echo "Failed to generate certificate for ${domain}"
    exit 1
  fi

  # Check if the certificate for the domain already exists in the ssl.yml file
  existing_cert=$(yq eval ".tls.certificates[] | select(.certFile == \"/etc/traefik/dynamic/${domain}.crt\" and .keyFile == \"/etc/traefik/dynamic/${domain}.key\")" /certificate-data/ssl.yml)
  if [ -z "$existing_cert" ]; then
    echo "Adding certificate for ${domain} to ssl.yml"
    # Add the certificate to the ssl.yml file
    yq eval -i ".tls.certificates += [{\"certFile\": \"/etc/traefik/dynamic/${domain}.crt\", \"keyFile\": \"/etc/traefik/dynamic/${domain}.key\"}]" /certificate-data/ssl.yml
  else
    echo "Certificate for ${domain} already exists in ssl.yml"
  fi

  if ! yq eval '.tls.certificates' /certificate-data/ssl.yml > /dev/null; then
    echo "Failed to update ssl.yml with the certificate for ${domain}"
    exit 1
  fi
done

# Signal that the service is healthy
touch /certificate-data/healthy

echo "Certificates generated and ssl.yml updated. Service is healthy."
