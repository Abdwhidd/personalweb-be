#!/bin/sh

# Laravel setup
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan storage:link || true

# Start server
echo "Starting server on port ${PORT:-8080}"
php -S 0.0.0.0:${PORT:-8080} -t public
