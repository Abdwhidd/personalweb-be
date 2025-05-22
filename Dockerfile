# FROM php:8.3-cli

# # Install system dependencies
# RUN apt-get update && apt-get install -y \
#     libzip-dev unzip git curl libpq-dev libicu-dev libxml2-dev \
#     && docker-php-ext-install intl pdo pdo_pgsql zip

# # Install Composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# WORKDIR /app

# COPY . .

# RUN composer install --no-dev --optimize-autoloader

# # Copy and make entrypoint executable
# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

# EXPOSE 8080

# CMD ["/entrypoint.sh"]



FROM php:8.3-fpm

# Install PHP dependencies & system tools
RUN apt-get update && apt-get install -y \
    git curl unzip libzip-dev libpq-dev libicu-dev libxml2-dev libonig-dev \
    && docker-php-ext-install intl pdo pdo_pgsql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# ✅ Download Caddy (binary) langsung dari release resmi
RUN curl -L https://github.com/caddyserver/caddy/releases/download/v2.7.6/caddy_2.7.6_linux_amd64.tar.gz \
  | tar -xz -C /usr/bin caddy \
  && chmod +x /usr/bin/caddy

# Set working dir
WORKDIR /app
COPY . .

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

EXPOSE 8080

CMD ["sh", "-c", "\
if [ -z \"$APP_KEY\" ]; then echo '❌ APP_KEY is missing!'; exit 1; fi; \
php artisan config:clear && \
php artisan config:cache && \
php artisan route:cache && \
php artisan view:cache && \
php artisan migrate --force && \
php artisan vendor:publish --tag=filament-assets --force && \
php artisan storage:link || true && \
printf \"%s\\n\" \
  \"http://0.0.0.0:8080 {\" \
  \"    root * /app/public\" \
  \"    encode gzip\" \
  \"    php_fastcgi 127.0.0.1:9000\" \
  \"    file_server\" \
  \"}\" > /etc/Caddyfile && \
caddy run --config /etc/Caddyfile --adapter caddyfile"]
