# How to run
```bash
mkcert -install
mkcert -cert-file traefik/dynamic/cert.pem -key-file traefik/dynamic/key.pem "*.test" "*.traefik.test" "semver-actions.test"
docker-compose up
```

# How to make your own user:
```bash
echo $(htpasswd -nB admin) | sed -e s/\\$/\\$\\$/g
```

Then enter the password you want, and paste it into `TRAEFIK_DASHBOARD_CREDENTIALS` in the `.env` file.

https://dashboard.traefik.test
