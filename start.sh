#!/bin/sh

addgroup -g ${GID} caddy
adduser -h /home/caddy -s /bin/sh -D -G caddy -u ${UID} caddy

chown -R caddy:caddy /home/caddy
chown -R caddy:caddy /srv

su-exec caddy:caddy sh -c "/usr/local/bin/caddy --version"
su-exec caddy:caddy sh -c "/usr/local/bin/caddy -agree --conf /srv/config/Caddyfile"
