# aftrs-qBittorrent

A comprehensive qBittorrent solution featuring:
- **Native qBittorrent application** with full build infrastructure for Windows and Linux
- **Container image** with NordVPN-friendly defaults and VueTorrent UI
- **VueTorrent integration** as the default modern web interface

## Container Features

### Quick Start

**Custom qBittorrent image with reliable defaults for NordVPN-friendly operation (no port forwarding), tuned queueing, and first-boot config seeding for `/config`.**

- **Base image:** `lscr.io/linuxserver/qbittorrent:latest` (multi-arch, s6-overlay)
- **Config path:** `/config/qBittorrent/qBittorrent.conf` (LinuxServer image maps `/config` to host). First boot seeds defaults from `/defaults/qBittorrent.conf`
- **WebUI:** `http://<your-host>:8080` (change via `WEBUI_PORT` env) - **Now featuring VueTorrent UI by default!**
- **Container registry:** `ghcr.io/aftrs-void/aftrs-qbittorrent:<tag>`

> **Tip:** If you route the container through a VPN container/network (gluetun, etc.), **do not** bind qBittorrent to a specific interface in the conf by default—leave it empty so Docker networking handles it.

### Container Usage

```bash
# Using docker-compose (recommended)
cp container/examples/docker-compose.unraid.yml docker-compose.yml
# Edit the compose file for your setup
docker compose up -d

# Using docker run
docker run -d \
  --name=qbittorrent \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e WEBUI_PORT=8080 \
  -p 8080:8080 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -v /path/to/config:/config \
  -v /path/to/downloads:/downloads \
  --restart unless-stopped \
  ghcr.io/aftrs-void/aftrs-qbittorrent:latest
```

### Environment Variables

- `PUID`, `PGID` — set to your host user/group (Unraid common: 99/100)
- `TZ` — timezone, e.g., `America/Los_Angeles`
- `WEBUI_PORT`, `TORRENTING_PORT` — see LinuxServer docs; expose matching ports

### Container Configuration

The container includes opinionated defaults optimized for VPN usage:

- **No port forwarding dependency** (works great with Nord/Surfshark/etc.)
- **DHT/PeX/LSD enabled** for peer discovery
- **Conservative queueing** (6 active torrents, 4 downloads, 6 uploads)
- **Anonymous mode** enabled for privacy
- **VueTorrent UI** pre-installed and configured as default
- **Automatic config seeding** on first boot

### VueTorrent Integration

VueTorrent is a modern, responsive Vue.js-based web interface for qBittorrent that provides:

- **Modern UI/UX** with dark/light themes
- **Mobile-responsive design**
- **Advanced torrent management**
- **Real-time statistics and graphs**
- **Drag-and-drop torrent adding**
- **Plugin support**

The VueTorrent UI is automatically configured as the default interface and is accessible at the same WebUI port.

## Native Application Build

qBittorrent is a bittorrent client programmed in C++ / Qt that uses libtorrent (sometimes called libtorrent-rasterbar) by Arvid Norberg.

It aims to be a good alternative to all other bittorrent clients out there. qBittorrent is fast, stable and provides unicode support as well as many features.

### Installation

Refer to the [INSTALL](INSTALL) file for building the native application.

### Build Infrastructure

This repository includes comprehensive build infrastructure:

- **GitHub Actions CI** for Ubuntu, Windows, macOS, and WebUI testing
- **CMake build system** with feature detection
- **Cross-platform support** for major operating systems
- **Automated testing** and code quality checks

### Public Key

Starting from v3.3.4 all source tarballs and binaries are signed.
The key currently used is 4096R/[5B7CC9A2](https://pgp.mit.edu/pks/lookup?op=get&search=0x6E4A2D025B7CC9A2) with fingerprint `D8F3DA77AAC6741053599C136E4A2D025B7CC9A2`.
You can also download it from [here](https://github.com/qbittorrent/qBittorrent/raw/master/5B7CC9A2.asc).

## Development

### Container Development

The container configuration is located in the `container/` directory:

- `container/defaults/` - Default qBittorrent configuration
- `container/examples/` - Docker compose examples
- `container/extras/` - Additional documentation and guides
- `container/rootfs/` - Container initialization scripts
- `container/vuetorrent/` - VueTorrent UI files

### Building the Container

```bash
# Build locally
docker build -t aftrs-qbittorrent .

# Build with GitHub Actions (triggered by version tags)
git tag v1.0.0
git push origin v1.0.0
```

## Resources

- **Official qBittorrent:** https://www.qbittorrent.org
- **qBittorrent Wiki:** https://wiki.qbittorrent.org
- **VueTorrent Project:** https://github.com/VueTorrent/VueTorrent
- **Forum:** https://forum.qbittorrent.org
- **Bug Reports:** https://bugs.qbittorrent.org
- **IRC:** [#qbittorrent on irc.libera.chat](ircs://irc.libera.chat:6697/qbittorrent)

## License

This project maintains the same licensing as the upstream qBittorrent project. Container customizations are provided under MIT license.

The free [IP to Country Lite database](https://db-ip.com/db/download/ip-to-country-lite) by [DB-IP](https://db-ip.com/) is used for resolving the countries of peers. The database is licensed under the [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).

---

**Container:** aftrs-void
**Upstream:** qBittorrent Project
**UI Enhancement:** VueTorrent Project
