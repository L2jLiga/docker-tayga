FROM alpine:edge

LABEL org.opencontainers.image.authors="jiaxun.yang@flygoat.com"

ENV \
	TAYGA_CONF_DATA_DIR=/var/db/tayga \
	TAYGA_CONF_DIR=/usr/etc \
	TAYGA_CONF_IPV4_ADDR=172.18.0.100 \
	TAYGA_IPV6_ADDR=fdaa:bb:1::1 \
	TAYGA_CONF_PREFIX=64:ff9b::/96 \
	TAYGA_CONF_DYNAMIC_POOL=172.18.0.128/25

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing tayga
ADD docker-entry.sh /
RUN chmod +x /docker-entry.sh

ENTRYPOINT ["/docker-entry.sh"]
