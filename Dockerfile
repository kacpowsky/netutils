# netutils - a batteries-included network debugging toolbox.
#
# Author: kacpowsky <https://github.com/kacpowsky>
#
# Contains the tooling needed to troubleshoot DNS resolution and routing
# across a network: dig/kdig/drill, mtr, traceroute, nc, tcpdump and friends.
FROM debian:bookworm-slim

LABEL org.opencontainers.image.title="netutils" \
      org.opencontainers.image.description="Network, routing and DNS troubleshooting toolbox" \
      org.opencontainers.image.authors="kacpowsky" \
      org.opencontainers.image.vendor="kacpowsky" \
      org.opencontainers.image.source="https://github.com/kacpowsky/netutils"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    # --- DNS ---
    bind9-dnsutils \
    bind9-host \
    knot-dnsutils \
    ldnsutils \
    dnstracer \
    whois \
    # --- Routing / path analysis ---
    mtr-tiny \
    traceroute \
    tcptraceroute \
    iputils-ping \
    iputils-tracepath \
    iputils-arping \
    fping \
    iproute2 \
    net-tools \
    ethtool \
    bridge-utils \
    # --- Connectivity / sockets ---
    netcat-openbsd \
    socat \
    telnet \
    nmap \
    iperf3 \
    curl \
    wget \
    openssl \
    ca-certificates \
    # --- Packet capture & inspection ---
    tcpdump \
    ngrep \
    conntrack \
    # --- Misc helpers ---
    jq \
    xxd \
    less \
    procps \
    lsof \
    vim-tiny \
    bash \
    && rm -rf /var/lib/apt/lists/*

# `nc -vv` must work: pin the nc alternative to the OpenBSD implementation so
# the behaviour is deterministic regardless of package install order.
RUN update-alternatives --set nc /bin/nc.openbsd

WORKDIR /root

# Smoke-test the important tools at build time so a broken image never ships.
RUN command -v dig nslookup host kdig drill mtr traceroute tcptraceroute \
      ping fping nc socat nmap tcpdump ngrep ip ss curl openssl jq \
    && dig -v \
    && mtr --version \
    && nc -h 2>&1 | head -n1

# The image is meant to run as a long-lived debug pod that you `kubectl exec`
# into, so the default command must not exit: a plain `bash` with no TTY ends
# immediately and Kubernetes reports CrashLoopBackOff. Override the command if
# you want a one-shot run (e.g. `args: ["dig", "+trace", "example.com"]`).
CMD ["sleep", "infinity"]
