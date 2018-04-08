FROM ubuntu:16.04
MAINTAINER Sixphere <info@sixphere.com>

ENV DEBIAN_FRONTEND noninteractive

# Packages installation
RUN apt-get update && \
    apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -y --fix-missing install software-properties-common \
    curl \
    apt-transport-https \
    git \
    nano \
    lynx-cur \
    sudo \
    sshpass \
    iputils-ping \
    net-tools \
    dnsutils

# Install PHP 7.1
RUN sudo apt-get install software-properties-common && \
    sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    sudo apt-get update && \
    apt-get -y --fix-missing install \
    php7.1 \
    php7.1-cli \
    php7.1-common \
    php7.1-fpm \
    php7.1-gd \
    php7.1-json \
    php7.1-opcache \
    php7.1-mcrypt \
    php7.1-fpm \
    php7.1-dev \
    php7.1-mbstring \
    php7.1-xml \
    php7.1-xsl \
    php7.1-zip \
    php7.1-soap \
    php7.1-mysql \
    php7.1-curl \
    php-xdebug \
    php-pear

# install nginx
RUN apt-get install -y --force-yes nginx-full

# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.bashrc

# install nodejs
RUN apt-get install -y nodejs npm

# install supervisor
RUN apt-get install -y supervisor && \
    mkdir -p /var/log/supervisor
COPY stubs/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install filebeat
RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.2.2-amd64.deb && \
    sudo dpkg -i filebeat-6.2.2-amd64.deb && \
    rm filebeat-6.2.2-amd64.deb
COPY elk/filebeat.yml /etc/filebeat/

# config nginx
COPY stubs/homestead /etc/nginx/sites-available/
COPY stubs/fastcgi_params /etc/nginx/

RUN rm -rf /etc/nginx/sites-available/default && \
    rm -rf /etc/nginx/sites-enabled/default && \
    ln -fs "/etc/nginx/sites-available/homestead" "/etc/nginx/sites-enabled/homestead" && \
    sed -i -e "s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf && \
    sed -i -e "s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    usermod -u 1000 www-data && \
    chown -Rf www-data.www-data /var/www/html/ && \
    sed -i -e "s/worker_processes  1/worker_processes 5/" /etc/nginx/nginx.conf

# config php
RUN sed -i -e "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/cli/php.ini && \
    sed -i -e "s/display_errors = .*/display_errors = On/" /etc/php/7.1/cli/php.ini && \
    sed -i -e "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/cli/php.ini && \
    sed -i -e "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/fpm/php.ini && \
    sed -i -e "s/display_errors = .*/display_errors = On/" /etc/php/7.1/fpm/php.ini && \
    sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.1/fpm/php.ini && \
    sed -i -e "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.1/fpm/php.ini && \
    sed -i -e "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.1/fpm/php.ini && \
    sed -i -e "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.1/fpm/php-fpm.conf && \
    sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_children = 5/pm.max_children = 9/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i -e "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php/7.1/fpm/pool.d/www.conf && \
    find /etc/php/7.1/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \; && \
    mkdir -p /run/php/ && chown -Rf www-data.www-data /run/php

RUN mkdir /var/www/html/app
VOLUME ["/var/log/supervisor","/var/www/html/app","/var/cache/nginx","/var/log/nginx"]

# Arguments used for change filebeat
ARG KIBANA_HOST
ARG ELASTIC_SEARCH_HOST
ARG APP_DOMAIN

RUN sed -i "s/KIBANA_HOST/${KIBANA_HOST}/g" /etc/filebeat/filebeat.yml && \
    sed -i "s/ELASTIC_SEARCH_HOST/${ELASTIC_SEARCH_HOST}/g" /etc/filebeat/filebeat.yml && \
    sed -i "s/APP_DOMAIN/${APP_DOMAIN}/g" /etc/nginx/sites-available/homestead

# expose ports
EXPOSE 80 443 3306 6379

# set container entrypoints
COPY stubs/docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
