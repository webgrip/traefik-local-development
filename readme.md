# How it works
`docker-compose` runs the services
`traefik` routes the traffic to the correct service within the docker network
`dnsmasq` makes sure certain domains are routed to localhost
`mkcert` generates a root CA and installs it in `~/.config/mkcert` on YOUR local machine (!!!)
`mkcert` generates a certificate for the domains that are passed as arguments to the `entrypoint.sh` script
`entrypoint.sh` builds a configuration file with the entries of the certificates that it just generated in `ssl.yml`
`traefik` watches for changes in `ssl.yml` and reloads the certificates automatically

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
certutil -addstore -f "ROOT" ${HOME}/.config/mkcert/rootCA.pem
```
You may need to restart your browser (a few times)

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
    - "traefik.http.routers.YOUR-SERVICE-secure.service=YOUR-SERVICE"
    - "traefik.http.services.YOUR-SERVICE.loadbalancer.server.scheme=https"
    - "traefik.http.services.YOUR-SERVICE.loadbalancer.server.port=YOUR-PORT"

```

# How to add certificates for new domains
The preferred way it to add the following in the docker-compose.yml file of your project:
```yml
services:
    # ...
    YOUR-PROJECT-mkcert:
      container_name: YOUR-PROJECT-mkcert
      image: webgrip/traefik-local-development-mkcert:latest
      pull_policy: always
      volumes:
        - ~/.config/mkcert:/root/.local/share/mkcert:ro
        - certificate-data:/certificate-data:rw
      entrypoint: [ "/app/entrypoint.sh", "YOURDOMAIN.test" ]
    # ...
```

Don't forget to add the volume and the external network to the docker-compose.yml file of your project:
```yml
volumes:
  certificate-data:
    external: true

networks:
  default:
    external: true
    name: webgrip
```


