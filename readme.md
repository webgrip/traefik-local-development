# How it works
`traefik` routes the traffic
`dnsmasq` makes sure certain domains are routed to localhost
`mkcert` generates a certificate for the domains and the root CA in `~/.config/mkcert` on YOUR local machine (!!!)
`mkcert` builds a configuration file with the entries of those certificates `ssl.yml` and traefik automatically reads them
I use docker-compose to run the services

# Where it runs
https://dashboard.traefik.test

# How to run
```bash
echo $(htpasswd -nB admin) > .htpasswd 
docker-compose up
```

# How to trust your generated root certificate on macOS
```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/.config/mkcert/rootCA.pem
```

# How to trust your generated root certificate on Windows
```bash
# Run as administrator
certutil -addstore -f "ROOT" ~/.config/mkcert/rootCA.pem
```

# How to enable my docker-compose container to be sent through traefik-local-development?
```yml
services:
  YOUR-SERVICE:
    container_name: YOUR-SERVICE-NAME
    # etc... 
    labels:
    - "traefik.enable=true"
    - "traefik.http.middlewares.traefik-https-redirect.redirectscheme.scheme=https"
    - "traefik.http.middlewares.sslheaders.headers.customrequestheaders.X-Forwarded-Proto=https"
    - "traefik.http.routers.YOUR-SERVICE.entrypoints=http"
    - "traefik.http.routers.YOUR-SERVICE.rule=Host(`YOUR-DOMAIN.test`)"
    - "traefik.http.routers.YOUR-SERVICE.middlewares=traefik-https-redirect"
    - "traefik.http.routers.YOUR-SERVICE-secure.entrypoints=https"
    - "traefik.http.routers.YOUR-SERVICE-secure.rule=Host(`YOUR-DOMAIN.test`)"
    - "traefik.http.routers.YOUR-SERVICE-secure.tls=true"
    - "traefik.http.routers.YOUR-SERVICE-secure.tls.domains[0].main=YOUR-DOMAIN.test"
    - "traefik.http.routers.YOUR-SERVICE-secure.tls.domains[0].sans=*.YOUR-DOMAIN.test"
    - "traefik.http.routers.YOUR-SERVICE-secure.service=YOUR-DOMAIN"
```

# How to add certificates for new domains
The preferred way it to add the following in the docker-compose.yml file of your project:
```yml
YOUR-PROJECT-mkcert:
  container_name: YOUR-PROJECT-mkcert
  image: webgrip/traefik-mkcert:latest
  volumes:
    - ~/.config/mkcert:/root/.local/share/mkcert:ro
    - certificate-data:/certificate-data:rw
  entrypoint: [ "/app/entrypoint.sh", "YOURDOMAIN.test" ]
```

Don't forget to add the volume:
```yml
volumes:
  certificate-data:
    external: true
```


