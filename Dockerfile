FROM php:8.1-fpm-alpine
COPY composer.lock composer.json /var/www/

#Set working directory
WORKDIR /var/www
#Install dependecies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    postgresql-dev

#Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

#Install Extensions
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo pdo_pgsql pgsql zip exif pcntl
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install gd

RUN curl -sS https://getcomposer.org/installer | php -- --version=2.4.3 --install-dir=/usr/local/bin --filename=composer


#Add user for laravel app
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

#Copy existing application directory contents
COPY . /var/www

#Copy existing application directory permissions
COPY --chown=www:www . /var/www/

#Change current user to www
USER www

RUN composer install
RUN php artisan migrate --force

CMD ["php","artisan","serve","--host=0.0.0.0"]