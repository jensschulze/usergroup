FROM php:7.2-apache

# Define the installation directory
ENV APP_ROOT="/var/www/html"

# Install the PHP extensions we need
RUN set -ex; \
    \
    if command -v a2enmod; then \
        a2enmod rewrite; \
    fi; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libjpeg-dev \
        libpng-dev \
        libpq-dev \
        git \
    ; \
    \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
    docker-php-ext-install -j "$(nproc)" \
        gd \
        opcache \
        pdo_mysql \
        zip \
    ; \
    \
    rm -f /usr/local/apache2/logs/httpd.pid;

# Set recommended Opcache settings
# (see https://secure.php.net/manual/en/opcache.installation.php)
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Log PHP errors to STDERR
# Set a few common defaults
RUN { \
        echo 'error_log=/dev/stderr'; \
        echo 'error_reporting=-1'; \
        echo 'memory_limit=256M'; \
        echo 'upload_max_filesize=128M'; \
        echo 'post_max_size=128M'; \
        echo 'max_execution_time=600'; \
    } > /usr/local/etc/php/conf.d/zzzz-custom.ini

## Configure Apache vhost
COPY ./config/apache/20-httpd.conf /etc/httpd/conf.d/20-httpd.conf
RUN sed -ri -e 's!/var/www/html!${APP_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APP_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN { \
        echo '<VirtualHost *:80>'; \
        echo '	ServerAdmin webmaster@localhost'; \
        echo '	<Directory ${APP_ROOT}>'; \
        echo '	    AllowOverride All'; \
        echo '	    Require all granted'; \
        echo '	    Options FollowSymLinks'; \
        echo '	</Directory>'; \
        echo '	DocumentRoot ${APP_ROOT}/web'; \
        echo '	LogLevel info'; \
        echo '	ErrorLog "/dev/stderr"'; \
        echo '	CustomLog "/dev/stdout" combined'; \
        echo '</VirtualHost>'; \
    } > /etc/apache2/sites-enabled/000-default.conf

# Install Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install project dependencies with Composer
COPY composer.json composer.lock load.environment.php /var/www/html/
RUN composer global require hirak/prestissimo && \
    composer install -vvv --no-autoloader && \
    composer clearcache

WORKDIR $APP_ROOT

# Copy the whole project into $APP_ROOT and build the Composer Autoloader
COPY . .
RUN composer dump-autoload

# Set ownership for files/directories we have to write into
RUN chown -R www-data:www-data ./web/sites/default/private ./web/sites/default/files
