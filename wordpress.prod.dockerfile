# WordPress multisite image
# Installs WordPress multisite, PHP and PHP-FPM
# ##################################################
FROM --platform=linux/arm/v7 wordpress:6.5.3-php8.3-fpm-alpine

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

# Set permissions for wp-cli
RUN addgroup -g 1001 wp \
    && adduser -G wp -g wp -s /bin/sh -D wp \
    && chown wp:wp /var/www/html

# Add PHP multsite supporting files
COPY --chown=hale:hale opt/php/error-handling.php /usr/src/wordpress/error-handling.php
COPY --chown=hale:hale opt/php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY --chown=hale:hale opt/php/wp-cron-multisite.php /usr/src/wordpress/wp-cron-multisite.php

# Setup WordPress multisite and network
COPY --chown=hale:hale opt/scripts/hale-entrypoint.sh /usr/local/bin/
COPY --chown=hale:hale opt/scripts/config.sh /usr/local/bin/

# Generated Composer and NPM compiled artifacts (plugins, themes, CSS, JS)
# The WP offical Docker image expects files to be in /usr/src/wordpress
# but then will copy them over on launch of site to the /html directory.
COPY --chown=hale:hale /wordpress/wp-content/plugins /usr/src/wordpress/wp-content/plugins

# Load default production php.ini file in
# Custom php.ini additions for dev, staging & prod are done via k8s manifest
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Create new user to run the container as non-root
RUN adduser --disabled-password hale -u 1002 \
    && chown -R hale:hale /var/www/html \
    && chown hale:hale /usr/local/bin/docker-entrypoint.sh

# Make multisite scripts executable
RUN chmod +x /usr/local/bin/hale-entrypoint.sh \
    && chmod +x /usr/local/bin/config.sh

# Create the uploads folder
RUN mkdir -p /usr/src/wordpress/wp-content/uploads

# Overwrite offical WP image ENTRYPOINT (docker-entrypoint.sh)
# with custom entrypoint so we can launch WP multisite network
ENTRYPOINT ["/usr/local/bin/hale-entrypoint.sh"]

# Set container user 'root' to 'hale' that is set to 1002. Number is required
# instead of using user name.
USER 1002
