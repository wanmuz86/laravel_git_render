FROM php:8.1-fpm-alpine
WORKDIR /var/www/html

RUN apk update && \
    apk add bash build-base gcc wget git autoconf libmcrypt-dev \
    g++ make openssl-dev \
    php81-openssl \
    php81-pdo_mysql \
    php81-mbstring
RUN curl -sS https://getcomposer.org/installer | php -- --version=2.4.3 --install-dir=/usr/local/bin --filename=composer

COPY . .
RUN composer install
RUN php artisan migrate --force

CMD ["php","artisan","serve","--host=0.0.0.0"]