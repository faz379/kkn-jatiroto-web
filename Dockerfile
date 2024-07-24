# Tahap 1: Setup environment PHP
FROM php:8.2-fpm-alpine

# Instal dependensi
RUN apk add --no-cache bash git openssl

# Instal Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Salin file proyek
COPY composer.json composer.lock /var/www/

# Instal dependensi PHP
RUN composer install --prefer-dist --no-dev --no-scripts --no-progress --no-interaction

# Tahap 2: Setup aplikasi Laravel
COPY . /var/www/

# Atur direktori kerja
WORKDIR /var/www/

# Setel izin yang tepat
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www

# Buka port
EXPOSE 9000

# Mulai server PHP-FPM
CMD ["php-fpm"]
