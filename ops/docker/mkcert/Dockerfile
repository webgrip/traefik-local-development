# Use the official lightweight Alpine Linux image
FROM alpine:3.20.3

# Install necessary packages
RUN apk --no-cache add \
    curl \
    openssl \
    yq
RUN curl -L -o /usr/local/bin/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64

RUN chmod +x /usr/local/bin/mkcert

COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh
