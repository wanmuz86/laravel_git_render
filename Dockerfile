FROM php:8.1-fpm-alpine
WORKDIR /var/www/html

RUN apk update  
RUN apk install -y libpq-dev

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo pdo_pgsql

RUN curl -sS https://getcomposer.org/installer | php -- --version=2.4.3 --install-dir=/usr/local/bin --filename=composer

COPY . .
RUN composer install
RUN php artisan migrate --force

CMD ["php","artisan","serve","--host=0.0.0.0"]