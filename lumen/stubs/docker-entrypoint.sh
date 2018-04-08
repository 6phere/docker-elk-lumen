#!/bin/bash

set -eo pipefail
shopt -s nullglob

#Download project if not exists
if [ ! -d /var/www/html/app/.git ]
then
  ${GIT_COMMAND} /var/www/html/app/
  cd /var/www/html/app && \
      cp .env.example .env && \
      sed -i "/KIBANA_URL_SITE/c\KIBANA_URL_SITE=${KIBANA_URL_SITE}" /var/www/html/app/.env && \
      sed -i "/DB_HOST/c\DB_HOST=mysql" /var/www/html/app/.env && \
      composer install && \
      composer dump-autoload && \
      chown -R www-data:www-data . && \
      chmod -R 775 . && \
      php artisan key:generate && \
      php artisan sixphere:install
fi

until $(curl --output /dev/null --silent --head --fail http://${ELASTIC_SEARCH_HOST}); do
  echo "Waiting ELK Connection"
  sleep 5
done

if $(curl --output /dev/null --silent --head --fail http://${ELASTIC_SEARCH_HOST}); then
  echo "Enabling Filebeat"
  sudo filebeat modules enable nginx
  sudo filebeat setup
  sudo service filebeat start
fi
exec "$@"
