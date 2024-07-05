# Use the base image
FROM --platform=linux/arm/v7 wordpress:6.5.5-php8.3-fpm-alpine

ENV PHP_INI_DIR /usr/local/etc/php

# Install additional Alpine packages and wp-cli
RUN apk update && \
    apk add --no-cache less vim mysql-client htop && \
    curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp && \
    addgroup -g 1001 wp && \
    adduser -G wp -g wp -s /bin/sh -D wp && \
    adduser wp www-data

# Add PHP multisite supporting files
COPY opt/php/load.php /usr/src/wordpress/wp-content/mu-plugins/load.php
COPY opt/php/application.php /usr/src/wordpress/wp-content/mu-plugins/application.php
COPY opt/php/error-handling.php /usr/src/wordpress/error-handling.php
COPY opt/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY opt/php/wp-cron-multisite.php /usr/src/wordpress/wp-cron-multisite.php
COPY opt/php/php.ini $PHP_INI_DIR/conf.d/

# Setup WordPress multisite and network scripts
COPY opt/scripts/hale-entrypoint.sh /usr/local/bin/hale-entrypoint.sh
COPY opt/scripts/config.sh /usr/local/bin/config.sh

# Generated Composer and NPM compiled artifacts
COPY /wordpress/wp-content/mu-plugins /usr/src/wordpress/wp-content/mu-plugins
COPY /wordpress/wp-content/plugins /usr/src/wordpress/wp-content/plugins
COPY /wordpress/wp-content/themes /usr/src/wordpress/wp-content/themes
COPY /vendor /usr/src/wordpress/wp-content/vendor

# Set permissions for scripts and WordPress content
RUN chmod +x /usr/local/bin/hale-entrypoint.sh /usr/local/bin/config.sh && \
    mkdir -p /usr/src/wordpress/wp-content/uploads && \
    chown -R www-data:www-data /usr/src/wordpress/wp-content

# Overwrite official WP image ENTRYPOINT (docker-entrypoint.sh)
ENTRYPOINT ["/usr/local/bin/hale-entrypoint.sh"]

USER www-data
