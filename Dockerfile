FROM php:8.1-fpm-alpine
WORKDIR /var/www/html

RUN apk update 
RUN curl -sS https://getcomposer.org/installer | php -- --version=2.4.3 --install-dir=/usr/local/bin --filename=composer

COPY . .
RUN composer install
RUN php artisan migrate

CMD ["php","artisan","serve","--host=0.0.0.0"]