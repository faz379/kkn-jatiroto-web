# Gunakan image PHP dengan Composer dan Node.js
FROM composer:latest AS composer
FROM node:latest AS node

# Tahap 1: Install dependensi PHP menggunakan Composer
FROM php:8.0-fpm-alpine AS php
RUN apk add --no-cache bash git openssl

# Salin file composer.lock dan composer.json
COPY composer.json composer.lock /var/www/

# Instal dependensi PHP
RUN composer install --prefer-dist --no-dev --no-scripts --no-progress --no-interaction

# Tahap 2: Setup aplikasi Laravel
FROM php AS app
WORKDIR /var/www

# Salin semua file proyek
COPY . /var/www

# Salin vendor dari tahap 1
COPY --from=php /var/www/vendor /var/www/vendor

# Setel izin direktori storage dan cache
RUN chown -R www-data:www-data /var/www/storage /var/www/cache /var/www/bootstrap/cache

# Jalankan perintah setup Laravel
RUN php artisan optimize:clear && \
    php artisan storage:link && \
    php artisan migrate --force

# Setel perintah default container
CMD ["php-fpm"]
