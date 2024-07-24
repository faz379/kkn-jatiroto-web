# Gunakan image PHP dengan versi yang sesuai
FROM php:8.2-fpm-alpine

# Install dependensi yang diperlukan
RUN apk add --no-cache bash git openssl

# Copy Composer dari image resmi Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set workdir ke /var/www
WORKDIR /var/www

# Copy file composer.json dan composer.lock ke /var/www
COPY composer.json composer.lock ./

ENV COMPOSER_ALLOW_SUPERUSER=1

# Install dependensi Composer
RUN composer install --prefer-dist --no-dev --no-scripts --no-progress --no-interaction

# Copy seluruh kode sumber ke /var/www
COPY . .

# Expose port 9000 dan jalankan perintah yang sesuai
EXPOSE 8000
CMD ["php-fpm"]
