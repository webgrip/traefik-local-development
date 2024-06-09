# How it works
I use traefik to route the traffic
I use dnsmasq to make sure certain domains are routed to localhost
I use mkcert to generate a certificate for the domains
I use docker-compose to run the services

# How to run
```bash
echo $(htpasswd -nB admin) > .htpasswd
docker-compose up -d
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /path/to/rootCA.pem
```

# How to reload
```bash
docker kill --signal=HUP  <container id>
```

https://dashboard.traefik.test


