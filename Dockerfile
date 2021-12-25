FROM wordpress:latest

# Set up standard additions
RUN apt-get update && \
    apt-get install -y libldap2-dev zip sudo less zlib1g-dev

# Add additional PHP config changes
COPY uploads.ini /usr/local/etc/php/conf.d/uploads.ini

# Trigger initial LDAP Docker configure
ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions ldap pdo_mysql

# Add in WP-CLI
RUN curl -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
COPY wp-su.sh /bin/wp
RUN chmod +x /bin/wp-cli.phar /bin/wp

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
