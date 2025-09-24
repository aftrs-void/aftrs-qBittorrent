# aftrs-void/aftrs-qBittorrent
# Customized qBittorrent container with sane defaults for NordVPN-friendly operation.
# Base: LinuxServer.io qBittorrent (s6-overlay, multi-arch)
FROM lscr.io/linuxserver/qbittorrent:latest

LABEL org.opencontainers.image.source="https://github.com/aftrs-void/aftrs-qBittorrent"
LABEL org.opencontainers.image.description="qBittorrent with Nord-friendly defaults, VueTorrent UI, and first-boot seeding of config"
LABEL org.opencontainers.image.licenses="MIT"

# Defaults folder: we place qBittorrent.conf here and copy it to /config on first boot if missing.
COPY container/defaults/qBittorrent.conf /defaults/qBittorrent.conf

# Add VueTorrent UI
COPY container/vuetorrent/public/ /usr/local/qbittorrent/dist/

# Add an s6 custom init script to seed /config on first start.
# LinuxServer containers execute /custom-cont-init.d/* before services.
COPY container/rootfs/ /

# Environment knobs (override at runtime)
ENV PUID=1000 \
  PGID=1000 \
  TZ=Etc/UTC \
  WEBUI_PORT=8080 \
  TORRENTING_PORT=6881
