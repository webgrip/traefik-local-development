# How to run
```bash
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
# Move them to traefik/dynamic
docker-compose up
```

https://dashboard.traefik.test
