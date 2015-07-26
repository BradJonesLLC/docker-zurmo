#!/bin/bash

if [[ $SSL == 'FALSE' ]]; then a2dismod ssl; fi
if [[ $ENVIRONMENT == 'DEV' ]]; then php5enmod xdebug; fi

for dn in `cat /var/www/config/docker/web/web-writable.txt`; do
  chown www-data /var/www/$dn
done

chmod +x /var/www/public/app/protected/commands/zurmoc

if [[ ! -f /var/www/public/app/protected/config/perInstance.php ]]; then
  cd /var/www/public/app/protected/commands
  set -a
  : ${ZURMO_DB_PORT:=3306}
  : ${ZURMO_DB_HOST:=db}
  : ${ZURMO_DB:=zurmo}
  : ${ZURMO_DB_PASSWORD:=zurmo}
  : ${ZURMO_DB_USER:=zurmo}
  : ${ZURMO_SUPERUSER_PASS:=admin}
  : ${ZURMO_SCRIPT_URL:=/app/index.php}
  : ${ZURMO_SELF_URL:=http://localhost:8082}
  : ${ZURMO_MEMCACHE_SERVER:=memcache}
  : ${ZURMO_MEMCACHE_PORT:=11211}

  INSTALL_CMD="./zurmoc install $ZURMO_DB_HOST $ZURMO_DB $ZURMO_DB_USER \
  $ZURMO_DB_PASSWORD $ZURMO_DB_PORT $ZURMO_SUPERUSER_PASS $ZURMO_SELF_URL \
  $ZURMO_SCRIPT_URL $ZURMO_MEMCACHE_SERVER $ZURMO_MEMCACHE_PORT"
  if [[ -n "$ZURMO_DEMODATA" ]]; then INSTALL_CMD="$INSTALL_CMD $ZURMO_DEMODATA"; fi
  if [[ -n "$ZURMO_LOAD_MAGNITUDE" ]]; then INSTALL_CMD="$INSTALL_CMD $ZURMO_LOAD_MAGNITUDE"; fi
  bash -c "$INSTALL_CMD"
  cd ../config
  chmod u-w perInstance.php
  chmod u-w debug.php
fi;

source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND
