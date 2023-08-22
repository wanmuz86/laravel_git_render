FROM php:8.1-fpm-alpine
WORKDIR /var/www/html

RUN apk update 

RUN curl -sS https://getcomposer.org/installer | php -- --version=2.4.3 --install-dir=/usr/local/bin --filename=composer
RUN docker-php-ext-install pdo pdo_mysql
# for mysqli if you want
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
COPY . .
RUN composer install
RUN php artisan migrate --force

CMD ["php","artisan","serve","--host=0.0.0.0"]