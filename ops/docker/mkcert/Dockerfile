# Use the official lightweight Alpine Linux image
FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

# Install necessary packages
RUN apk --no-cache add \
    curl \
    openssl \
    yq
RUN curl -L -o /usr/local/bin/mkcert https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64

RUN chmod +x /usr/local/bin/mkcert

COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh
