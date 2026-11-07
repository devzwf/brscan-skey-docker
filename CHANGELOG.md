# Changelog

## [1.0.1] - 2026-11-07
- Ignore a duplicate button event received while a scan is already running (it produced an extra blank page from the glass).

## [1.0.0] - 2026-11-07
- First release: Brother "Scan to PC" button → multi-page PDF in a folder.
- brscan4 0.4.11-1 and brscan-skey 0.3.6-0 (Brother), Debian trixie.
- Feeder batch with flatbed fallback, JPEG / CCITT G4 PDF, atomic drop, configurable owner (PUID/PGID).
- Page size presets (Letter, A4, Legal), configurable resolution, mode, SNMP community and name shown on the device.
