# Use the base image
FROM --platform=linux/arm/v7 wordpress:6.5.5-php8.3-fpm-alpine

# Install additional Alpine packages
RUN apk update && \
    apk add less \
    vim \
    mysql \
    mysql-client \
    htop

# Install wp-cli
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

# Set up permissions for wp-cli
RUN addgroup -g 1001 wp \
    && adduser -G wp -g wp -s /bin/sh -D wp \
    && adduser wp www-data

# Add PHP multisite supporting files
COPY opt/php/load.php /usr/src/wordpress/wp-content/mu-plugins/load.php
COPY opt/php/application.php /usr/src/wordpress/wp-content/mu-plugins/application.php
COPY opt/php/error-handling.php /usr/src/wordpress/error-handling.php
COPY opt/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY opt/php/wp-cron-multisite.php /usr/src/wordpress/wp-cron-multisite.php

# Setup WordPress multisite and network
COPY opt/scripts/hale-entrypoint.sh /usr/local/bin/
COPY opt/scripts/config.sh /usr/local/bin/

# Generated Composer and NPM compiled artifacts (plugins, themes, CSS, JS)
# The WP official Docker image expects files to be in /usr/src/wordpress
# but then will copy them over on launch of the site to the /html directory.
COPY /wordpress/wp-content/plugins /usr/src/wordpress/wp-content/plugins
COPY /wordpress/wp-content/mu-plugins /usr/src/wordpress/wp-content/mu-plugins
COPY /wordpress/wp-content/themes /usr/src/wordpress/wp-content/themes
COPY /vendor /usr/src/wordpress/wp-content/vendor

# Load default production php.ini file
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Make multisite scripts executable
RUN chmod +x /usr/local/bin/hale-entrypoint.sh \
    && chmod +x /usr/local/bin/config.sh

# Create the uploads folder with correct permissions
RUN mkdir -p /usr/src/wordpress/wp-content/uploads

# Change ownership of wp-content and its subfolders to www-data
RUN chown -R www-data:www-data /usr/src/wordpress/wp-content

# Overwrite official WP image ENTRYPOINT (docker-entrypoint.sh)
# with a custom entrypoint so we can launch WP multisite network
ENTRYPOINT ["/usr/local/bin/hale-entrypoint.sh"]

# Set container user to 'www-data'
USER www-data
