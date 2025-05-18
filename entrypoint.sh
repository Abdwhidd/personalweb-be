#!/bin/sh

# Pastikan APP_KEY ada dari ENV Railway
if [ -z "$APP_KEY" ]; then
  echo "❌ APP_KEY is missing from environment!"
  exit 1
fi

echo "APP_KEY: $APP_KEY"

# Laravel setup
composer install --optimize-autoloader
php artisan config:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan migrate --force
php artisan storage:link || true

# Start server
echo "✅ Starting server on port ${PORT:-8080}"
php -S 0.0.0.0:${PORT:-8080} -t public
