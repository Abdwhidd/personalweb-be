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

# Install PHP & system dependencies
RUN apt-get update && apt-get install -y \
    git curl unzip gnupg2 libzip-dev libpq-dev libicu-dev libxml2-dev libonig-dev debian-keyring debian-archive-keyring \
    && docker-php-ext-install intl pdo pdo_pgsql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# ✅ Install Caddy (official)
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-archive-keyring.gpg \
 && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
 && apt-get update \
 && apt-get install -y caddy

# Set working directory
WORKDIR /app
COPY . .

# Install Laravel dependencies
RUN composer install --optimize-autoloader --no-dev

# Expose port for Railway
EXPOSE 8080

# ✅ Run Laravel setup & start Caddy (runtime)
CMD ["sh", "-c", "\
if [ -z \"$APP_KEY\" ]; then echo '❌ APP_KEY not set!'; exit 1; fi; \
php artisan config:clear && \
php artisan config:cache && \
php artisan route:cache && \
php artisan view:cache && \
php artisan migrate --force && \
php artisan storage:link || true && \
echo 'http://0.0.0.0:8080 { \
    root * /app/public \
    encode gzip \
    php_fastcgi 127.0.0.1:9000 \
    file_server \
}' > /etc/Caddyfile && \
caddy run --config /etc/Caddyfile --adapter caddyfile"]
