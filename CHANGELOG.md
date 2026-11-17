# Changelog

## [1.0.2] - 2026-11-16
- Accept older models that brscan4 lists only in `Brsane4.ini` (e.g. DCP-7065DN), and show them in `list-models` ([#1](https://github.com/devzwf/brscan-skey-docker/issues/1), thanks @RumbleInTheJungle).

## [1.0.1] - 2026-11-07
- Ignore a duplicate button event received while a scan is already running (it produced an extra blank page from the glass).

## [1.0.0] - 2026-11-07
- First release: Brother "Scan to PC" button → multi-page PDF in a folder.
- brscan4 0.4.11-1 and brscan-skey 0.3.6-0 (Brother), Debian trixie.
- Feeder batch with flatbed fallback, JPEG / CCITT G4 PDF, atomic drop, configurable owner (PUID/PGID).
- Page size presets (Letter, A4, Legal), configurable resolution, mode, SNMP community and name shown on the device.
