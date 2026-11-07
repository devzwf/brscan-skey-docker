# brscan-skey — Brother "Scan to PC" button → multi-page PDF in a folder
FROM debian:trixie-slim

ARG VERSION=dev
ARG BRSCAN4_URL=https://download.brother.com/welcome/dlf105200/brscan4-0.4.11-1.amd64.deb
ARG BRSCAN4_SHA256=027b73648722ac8c8eb1a9c419d284a6562cc763feac9740a2b75a683b092972
ARG SCANBTN_URL=https://download.brother.com/welcome/dlf006652/brscan-skey-0.3.6-0.amd64.deb
ARG SCANBTN_SHA256=26b480e747a61592e401ecf900fd22de69bc680cb80a130e7a2e8665180cf37c

LABEL org.opencontainers.image.title="brscan-skey" \
      org.opencontainers.image.description="Brother network scanner 'Scan to PC' button → multi-page PDF in a folder (Paperless-ngx consume, etc.)" \
      org.opencontainers.image.source="https://github.com/devzwf/brscan-skey-docker" \
      org.opencontainers.image.licenses="MIT AND LicenseRef-Brother" \
      org.opencontainers.image.version="${VERSION}"

# curl is a hard dependency of the brscan-skey package: do not purge it
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        sane-utils python3 python3-pil python3-img2pdf \
        iproute2 procps util-linux tini ca-certificates curl tzdata; \
    cd /tmp; \
    curl -fsSL -o brscan4.deb "$BRSCAN4_URL"; echo "$BRSCAN4_SHA256  brscan4.deb" | sha256sum -c -; \
    curl -fsSL -o skey.deb "$SCANBTN_URL";       echo "$SCANBTN_SHA256  skey.deb"       | sha256sum -c -; \
    dpkg -i --force-all brscan4.deb skey.deb; \
    test -x /opt/brother/scanner/brscan-skey/brscan-skey-exe; \
    test -x /opt/brother/scanner/brscan4/brsaneconfig4; \
    rm -f /tmp/*.deb; rm -rf /var/lib/apt/lists/*; \
    echo "$VERSION" > /etc/brscan-skey-version

COPY rootfs/ /
RUN chmod 755 /opt/scan/*

ENV SCANNER_IP="" \
    SCANNER_MODEL="" \
    SCANNER_NAME=Brother \
    SKEY_USER=brscan \
    SNMP_COMMUNITY=internal \
    OUTPUT_DIR=/output \
    FILENAME_PREFIX=scan \
    SCAN_RESOLUTION=300 \
    SCAN_MODE="True Gray" \
    SCAN_PAGE_SIZE=Letter \
    SCAN_WIDTH_MM="" \
    SCAN_HEIGHT_MM="" \
    JPEG_QUALITY=80 \
    PUID=99 \
    PGID=100 \
    TZ=Etc/UTC

VOLUME ["/output"]

HEALTHCHECK --interval=60s --timeout=5s --start-period=20s \
    CMD pgrep -x brscan-skey-exe >/dev/null || exit 1

ENTRYPOINT ["/usr/bin/tini", "--", "/opt/scan/entrypoint.sh"]
