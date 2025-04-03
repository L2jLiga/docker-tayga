#!/bin/bash

# Create Tayga directories.
mkdir -p "$TAYGA_CONF_DATA_DIR" "$TAYGA_CONF_DIR"

# Configure Tayga
tee "$TAYGA_CONF_DIR"/tayga.conf > /dev/null <<EOF
tun-device nat64
ipv4-addr ${TAYGA_CONF_IPV4_ADDR}
ipv6-addr ${TAYGA_IPV6_ADDR}
prefix ${TAYGA_CONF_PREFIX}
dynamic-pool ${TAYGA_CONF_DYNAMIC_POOL}
data-dir /var/spool/tayga
strict-frag-hdr ${TAYGA_CONF_FRAG}
EOF

# Setup Tayga networking
echo 0 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
tayga -c "$TAYGA_CONF_DIR"/tayga.conf --mktun
ip link set nat64 up
ip route add "$TAYGA_CONF_DYNAMIC_POOL" dev nat64
ip route add "$TAYGA_CONF_PREFIX" dev nat64

_term() {
    echo "Caught SIGTERM signal!"
    kill -TERM "$child" 2> /dev/null
    ip route del "$TAYGA_CONF_PREFIX" dev nat64
    ip route del "$TAYGA_CONF_DYNAMIC_POOL" dev nat64
    ip link set nat64 down
    tayga -c "$TAYGA_CONF_DIR"/tayga.conf --rmtun
}

trap _term SIGTERM

# Run Tayga
tayga -c "$TAYGA_CONF_DIR"/tayga.conf -d >> /proc/1/fd/1 &

child=$!
wait "$child"
