#!/bin/sh

# Pastikan .env tersedia
if [ ! -f .env ]; then
  cp .env.example .env
fi

# Laravel setup
composer install --optimize-autoloader
php artisan key:generate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan migrate --force
php artisan storage:link || true

# Start server
echo "Starting server on port ${PORT:-8080}"
php -S 0.0.0.0:${PORT:-8080} -t public
