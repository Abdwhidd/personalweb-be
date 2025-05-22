#!/bin/sh

echo "👉 Starting Laravel setup..."

if [ -z "$APP_KEY" ]; then
  echo "❌ APP_KEY is missing! Exiting."
  exit 1
fi

composer install --optimize-autoloader

php artisan config:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan migrate --force
php artisan storage:link || true
php artisan vendor:publish --tag=filament-assets --force

echo "✅ Laravel setup done."

echo "🧪 Checking index.php..."
ls -lah public/index.php

echo "🚀 Starting PHP server on port ${PORT:-8080}..."
php -S 0.0.0.0:${PORT:-8080} -t public
