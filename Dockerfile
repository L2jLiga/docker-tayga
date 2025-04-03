FROM debian:trixie

LABEL \
    maintainer="L2jLiga <l2jliga@gmail.com>" \
    org.opencontainers.image.title="tayga" \
    org.opencontainers.image.description="Docker image for NAT64 using Tayga" \
    org.opencontainers.image.vendor="L2jLiga" \
    org.opencontainers.image.authors="L2jLiga <l2jliga@gmail.com>" \
    org.opencontainers.image.licenses="Apache License 2.0" \
    org.opencontainers.image.source="https://github.com/L2jLiga/docker-tayga" \
    org.opencontainers.image.documentation="https://github.com/L2jLiga/docker-tayga/blob/master/README.md" \
    org.opencontainers.image.version="0.9.2-10"

ENV \
    TAYGA_CONF_IPV4_ADDR=172.18.0.100 \
    TAYGA_IPV6_ADDR=fdaa:bb:1::1 \
    TAYGA_CONF_PREFIX=64:ff9b::/96 \
    TAYGA_CONF_DYNAMIC_POOL=172.18.0.128/25 \
    TAYGA_CONF_FRAG=true

RUN apt-get update && \
    apt-get install tayga -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY docker-entry.sh /
RUN chmod +x /docker-entry.sh

# Labels
ENTRYPOINT ["/docker-entry.sh"]
