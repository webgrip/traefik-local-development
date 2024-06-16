FROM otel/opentelemetry-collector-contrib@sha256:0d928e02b0ef5abbba775da205eb102f58b29aa75ea623465ec42445dfc5c443
COPY config.yml /etc/otelcol-contrib/config.yaml

ENTRYPOINT ["/otelcol-contrib"]
CMD ["--config", "/etc/otelcol-contrib/config.yaml"]
