# brscan-skey

| [![Version][b-ver]][l-tags] | [![Pulls][b-pulls]][l-hub] | [![Size][b-size]][l-tags] | [![GitHub][b-gh]][l-gh] | [![License][b-lic]][l-lic] |
|---|---|---|---|---|

[b-ver]: https://img.shields.io/docker/v/devzwf/brscan-skey?sort=semver&logo=docker&label=version
[b-pulls]: https://img.shields.io/docker/pulls/devzwf/brscan-skey?logo=docker
[b-size]: https://img.shields.io/docker/image-size/devzwf/brscan-skey?sort=semver&label=size
[b-gh]: https://img.shields.io/badge/source-GitHub-181717?logo=github
[b-lic]: https://img.shields.io/github/license/devzwf/brscan-skey-docker
[l-tags]: https://hub.docker.com/r/devzwf/brscan-skey/tags
[l-hub]: https://hub.docker.com/r/devzwf/brscan-skey
[l-gh]: https://github.com/devzwf/brscan-skey-docker
[l-lic]: https://github.com/devzwf/brscan-skey-docker/blob/main/LICENSE

Press **SCAN → Scan to PC** on a Brother network scanner and get a **multi-page PDF** in a folder, such as the Paperless-ngx `consume` folder or a share.

Use it on Brother models without a "Scan to FTP / Network" menu (many North American models).

📖 **Full documentation, troubleshooting and source code: [github.com/devzwf/brscan-skey-docker](https://github.com/devzwf/brscan-skey-docker)**

## Supported tags

| Tag | Description |
|---|---|
| `latest` | Latest release |
| `1.0`, `1.0.1` | Pinned version, see the [changelog](https://github.com/devzwf/brscan-skey-docker/blob/main/CHANGELOG.md) |

Platform: **linux/amd64** only, because Brother ships x86 drivers only. Every tag is rebuilt weekly for Debian security updates.

## Before you start

1. Run the container with **host networking**. The device sends the button event to UDP port 54925.
2. On the device web page, go to **Network → Network → Protocol → SNMP** and choose **SNMP v1/v2c read-write access**. Otherwise the device shows **"No PC found"**.

## Quick start

```yaml
services:
  brscan-skey:
    image: devzwf/brscan-skey:latest
    container_name: brscan-skey
    network_mode: host
    restart: unless-stopped
    environment:
      SCANNER_IP: 192.168.1.50      # your Brother device
      SCANNER_MODEL: DCP-L2550DW    # exact model name
      SKEY_USER: Paperless          # name shown on the device
      TZ: America/Toronto
    volumes:
      - /path/to/paperless/consume:/output
```

Then press **SCAN → Scan to PC → File → OK** on the device.

Supported models (about 400, brscan4 driver):

```bash
docker run --rm --entrypoint list-models devzwf/brscan-skey
```

## Main settings

| Variable | Default | |
|---|---|---|
| `SCANNER_IP` | *required* | Device IP address |
| `SCANNER_MODEL` | *required* | Model name, e.g. `DCP-L2550DW` |
| `SKEY_USER` | `brscan` | Name shown in the Scan to PC menu |
| `SCAN_RESOLUTION` | `300` | dpi |
| `SCAN_MODE` | `True Gray` | `Black & White`, `True Gray`, `24bit Color[Fast]`… |
| `SCAN_PAGE_SIZE` | `Letter` | `Letter`, `A4`, `Legal` |
| `PUID` / `PGID` | `99` / `100` | Owner of the PDF files |

All variables are listed in the [README on GitHub](https://github.com/devzwf/brscan-skey-docker#settings).

## Unraid

The template is available in **Community Applications**: search for *brscan-skey*.

## Support

Report bugs and ask questions in [GitHub issues](https://github.com/devzwf/brscan-skey-docker/issues).

---

The scripts are under the MIT license. The Brother drivers are redistributed under the [Brother License Agreement](https://github.com/devzwf/brscan-skey-docker/blob/main/THIRD_PARTY.md). This project is not affiliated with Brother Industries, Ltd.
