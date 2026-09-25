# netutils

A container image with the tools needed to debug DNS resolution and network
routing: `dig`, `mtr`, `traceroute`, `nc`, `tcpdump` and friends.

## Usage

The default command is `sleep infinity`, so the container works both as a
throwaway Docker container and as a long-lived pod you exec into.

```sh
docker run --rm -it --cap-add=NET_RAW --cap-add=NET_ADMIN \
  ghcr.io/kacpowsky/netutils bash
```

```sh
kubectl run netutils --image=ghcr.io/kacpowsky/netutils:latest --restart=Never
kubectl exec -it netutils -- bash
```

Examples:

```sh
dig +trace example.com
mtr -rwzbc 20 1.1.1.1
nc -vv example.com 443
tcpdump -ni any port 53
```

## What's inside

- **DNS** — `dig`, `nslookup`, `host`, `kdig`, `drill`, `dnstracer`, `whois`
- **Routing** — `mtr`, `traceroute`, `tcptraceroute`, `tracepath`, `ping`,
  `fping`, `arping`, `ip`, `ss`, `netstat`, `ethtool`
- **Connectivity** — `nc` (OpenBSD), `socat`, `telnet`, `nmap`, `iperf3`,
  `curl`, `wget`, `openssl`
- **Capture** — `tcpdump`, `ngrep`, `conntrack`
- **Helpers** — `jq`, `lsof`, `xxd`, `less`, `vim-tiny`

## Building

```sh
docker buildx build --platform linux/amd64,linux/arm64 -t netutils .
```

CI builds both architectures and publishes to GHCR on pushes to `main` and on
`v*` tags. It authenticates with the per-run `GITHUB_TOKEN` that GitHub mints
for the job, so no registry credentials are stored in the repository.

## Author

Created and maintained by [kacpowsky](https://github.com/kacpowsky).
