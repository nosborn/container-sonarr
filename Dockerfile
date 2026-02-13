FROM debian:13.3-slim

ARG VERSION

ENV COMPlus_EnableDiagnostics=0

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        libicu76 \
        libsqlite3-0 \
        xmlstarlet \
    && rm -rf \
        /var/lib/apt/lists/* \
    && mkdir -p /app \
    && chown 1000:1000 /app

USER 1000:1000

RUN cd /app \
    && curl -fLsS \
        --output /tmp/Sonarr.tar.gz \
        --url "https://github.com/Sonarr/Sonarr/releases/download/v${VERSION:?}/Sonarr.main.${VERSION:?}.linux-x64.tar.gz" \
    && tar -xzf /tmp/Sonarr.tar.gz \
        --exclude=Sonarr.Update \
        --strip-components=1 \
    && rm /tmp/Sonarr.tar.gz

EXPOSE 8989
VOLUME /data
VOLUME /library

ENTRYPOINT ["/app/Sonarr", "-data=/data", "-nobrowser"]
