FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl unzip libzip-dev libpq-dev libicu-dev libxml2-dev libonig-dev \
    && docker-php-ext-install intl pdo pdo_pgsql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Caddy (standalone binary)
RUN curl -L https://github.com/caddyserver/caddy/releases/download/v2.7.6/caddy_2.7.6_linux_amd64.tar.gz \
  | tar -xz -C /usr/bin caddy && chmod +x /usr/bin/caddy

WORKDIR /app
COPY . .

RUN composer install --no-dev --optimize-autoloader

# ✅ Caddyfile using injected $PORT
RUN printf "%s\n" \
  "http://0.0.0.0:${PORT:-80} {" \
  "  root * /app/public" \
  "  encode gzip" \
  "  php_fastcgi unix//run/php/php-fpm.sock" \
  "  file_server" \
  "}" > /etc/Caddyfile

EXPOSE 80

CMD sh -c "\
mkdir -p /run/php && \
php artisan config:clear && \
php artisan config:cache && \
php artisan route:cache && \
php artisan view:clear && php artisan view:cache && \
php artisan migrate --force && \
php artisan filament:install && \
php artisan vendor:publish --tag=filament-assets --force && \
php artisan storage:link || true && \
tail -n 50 storage/logs/laravel.log || echo 'No Laravel error log' && \
php-fpm -y /usr/local/etc/php-fpm.conf -D && \
caddy run --config /etc/Caddyfile --adapter caddyfile"
