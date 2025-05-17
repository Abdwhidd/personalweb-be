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
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan migrate --force || true
RUN php artisan storage:link || true

EXPOSE 8080

CMD php -S 0.0.0.0:8080 -t public
