# qBittorrent + NordVPN (2025) — Known-Good Setup

**Targets:** Windows 10/11, qBittorrent 5.1.x, NordVPN (NordLynx preferred).  
**Goal:** Reliable magnets (no more *Downloading metadata*), avoid Comcast shaping, no leaks.

---

## 1) Prep NordVPN

- Use **NordLynx** (WireGuard). If magnets stall on your segment, briefly try **OpenVPN (UDP)** then switch back.
- Turn **Kill Switch** on.
- Choose a nearby **standard** server; if DPI is cranky, try **Obfuscated** servers.
- NordVPN **does not support port forwarding**, so we’ll rely on DHT/PeX/trackers, not inbound ports.

## 2) Bind qBittorrent to the VPN

- In **Tools → Options → Advanced**:
  - **Network interface**: select NordLynx/TUN/TAP (your VPN adapter).
  - Leave **Optional IP address to bind to** empty unless you know the VPN IP.
- Restart **VPN → qBittorrent** in that order whenever you change the bind.

> This prevents traffic if the VPN drops and fixes “stuck on metadata” when UDP couldn’t route.

## 3) BitTorrent tab (critical)

- **DHT/PeX/LSD**: **Enable all** (vital without port forwarding).  
- **Encryption**: **Prefer encryption** (don’t force; you’re already in a VPN tunnel).  
- **Anonymous mode**: **Enable** (minor privacy hardening).

## 4) Connection + Speed

- **Port**: any high port (e.g., 49160). **UPnP/NAT-PMP: Off** (no PF on NordVPN).
- **µTP**: On and **Apply rate limit to µTP**.
- **Upload cap**: after testing, set to ~70–80% of real upstream to avoid bufferbloat (start unlimited, measure, then tune).
- **Queueing**: Max active torrents 6, downloads 4, uploads 6 (reduce burstiness and disk thrash).

## 5) Quick health checks

- Status bar should show **hundreds of DHT nodes**. If 0 → firewall/UDP issue.
- Right-click stuck torrent → **Force re-announce**; if still stuck → **Force recheck** → add a few public trackers.
- **Leak test**: open `ipleak.net` → “Torrent Address detection” magnet. The displayed IP must be Nord’s, not Comcast’s.

## 6) Comcast-specific notes

- Comcast Business tends to shape obvious BitTorrent patterns. Binding to VPN + µTP rate-limiting + modest queue sizes reduces heuristics. Obfuscated servers can help if congestion persists.

## 7) Drop-in config

Use the included `qBittorrent_known_good.ini` as a starting point, then tweak:
- Change `Connection\Interface` to match your VPN adapter name (e.g., `NordLynx`).
- Adjust `Downloads\SavePath` and your speed limits.

### Windows paths

Place the INI at: `%APPDATA%\qBittorrent\qBittorrent.ini`  
(Stop qBittorrent first; back up your original.)

---

## Appendix: recommended Nord servers

Test set: `us10418`, `us10521`, `us10421`, `us10417` (`*.nordvpn.com`). Use whichever is closest/fastest for you.
