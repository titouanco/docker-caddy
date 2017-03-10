FROM alpine:3.5
LABEL maintainer "Titouan Condé <eownis+docker@titouan.co>"
LABEL org.label-schema.vcs-url="https://gitlab.com/eownis/docker-caddy"

ARG CADDY_FEATURES
ARG APK_PACKAGES

ENV UID="991" \
    GID="991" \
    CADDY_SRC_URL="https://caddyserver.com/download/build?os=linux&arch=amd64&features=$CADDY_FEATURES"

RUN apk add --no-cache curl libcap su-exec tini $APK_PACKAGES \
    ## Download Caddy
    && mkdir -p /tmp/caddy \
    && cd /tmp/caddy \
    && curl -o caddy.tar.gz "$CADDY_SRC_URL" \
    && tar xf /tmp/caddy/caddy.tar.gz -C /tmp/caddy \
    && mv /tmp/caddy/caddy /usr/local/bin/caddy \
    # Set permission to bind port 80 and 443
    && setcap cap_net_bind_service=+ep /usr/local/bin/caddy \
    # Cleaning
    && apk del libcap \
    && rm -rf /tmp/caddy

COPY index.html /srv/www/default/index.html
COPY Caddyfile /srv/config/Caddyfile

COPY start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh

VOLUME /srv/www /srv/config /srv/log
EXPOSE 80 443 2015

WORKDIR /srv

CMD ["/sbin/tini", "--", "/usr/bin/start.sh"]
