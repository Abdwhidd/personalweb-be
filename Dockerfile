FROM php:8.3-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev unzip git curl libpq-dev libicu-dev libxml2-dev \
    && docker-php-ext-install intl pdo pdo_pgsql zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

COPY . .

RUN composer install --no-dev --optimize-autoloader

# Copy and make entrypoint executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

CMD ["/entrypoint.sh"]



# FROM php:8.3-fpm

# RUN apt-get update && apt-get install -y \
#     git curl unzip libzip-dev libpq-dev libicu-dev libxml2-dev libonig-dev \
#     && docker-php-ext-install intl pdo pdo_pgsql zip

# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# RUN curl -fsSL https://getcaddy.com | bash -s personal

# WORKDIR /app
# COPY . .

# RUN composer install --optimize-autoloader --no-dev

# RUN php artisan config:clear \
#  && php artisan config:cache \
#  && php artisan route:cache \
#  && php artisan view:cache \
#  && php artisan migrate --force \
#  && php artisan storage:link || true

# EXPOSE 8080

# CMD ["sh", "-c", "\
# if [ -z \"$APP_KEY\" ]; then echo '❌ APP_KEY not set!'; exit 1; fi; \
# echo 'http://0.0.0.0:8080 { \
#     root * /app/public \
#     encode gzip \
#     php_fastcgi 127.0.0.1:9000 \
#     file_server \
# }' > /etc/Caddyfile \
# && caddy run --config /etc/Caddyfile --adapter caddyfile"]
