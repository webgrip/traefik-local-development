# How it works
I use traefik to route the traffic
I use dnsmasq to make sure certain domains are routed to localhost
I use mkcert to generate a certificate for the domains
I use docker-compose to run the services

# How to run
```bash
mkcert -install
mkcert -cert-file traefik/dynamic/cert.pem -key-file traefik/dynamic/key.pem "*.test" "*.traefik.test" "semver-actions.test"
echo $(htpasswd -nB admin) > .htpasswd
docker-compose up
```

https://dashboard.traefik.test


