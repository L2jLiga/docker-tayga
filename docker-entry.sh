#!/bin/sh

# Configure Tayga
tee /etc/default/tayga > /dev/null <<EOF
# Defaults for tayga initscript
# sourced by /etc/init.d/tayga
# installed at /etc/default/tayga by the maintainer scripts

# Configure interface and set the routes up
CONFIGURE_IFACE="yes"

# Configure NAT44 for the private IPv4 range
CONFIGURE_NAT44="no"

# Additional options that are passed to the Daemon.
DAEMON_OPTS=""

# IPv4 address to assign to the NAT64 tunnel device
IPV4_TUN_ADDR="${TAYGA_CONF_IPV4_ADDR}"

# IPv6 address to assign to the NAT64 tunnel device
IPV6_TUN_ADDR="${TAYGA_IPV6_ADDR}"
EOF

tee /etc/tayga.conf > /dev/null <<EOF
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

# Run Tayga
/etc/init.d/tayga start
