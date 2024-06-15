# Use the official lightweight Alpine Linux image
FROM alpine:latest

# Install necessary packages
RUN apk --no-cache add \
    curl \
    openssl

RUN curl -L -o /usr/local/bin/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64

RUN chmod +x /usr/local/bin/mkcert

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
