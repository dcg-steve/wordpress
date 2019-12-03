FROM wordpress:php7.1

# Set up standard additions
RUN apt-get update && apt-get install -y libldap2-dev zip sudo less zlib1g-dev

# Add additional PHP config changes
COPY uploads.ini /usr/local/etc/php/conf.d/uploads.ini

# Trigger initial LDAP Docker configure
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && docker-php-ext-install ldap zip pdo_mysql

# Add in WP-CLI
RUN curl -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
COPY wp-su.sh /bin/wp
RUN chmod +x /bin/wp-cli.phar /bin/wp
#RUN echo "alias wp='/usr/local/bin/wpcli --allow-root'" >> /root/.bashrc

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
