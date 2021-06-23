FROM php:7.4-fpm

RUN mkdir /app && chmod 775 /app

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y libmcrypt-dev zip unzip git \
    libmagickwand-dev --no-install-recommends \
    && docker-php-ext-install pdo_mysql pcntl bcmath

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev

RUN chown -R www-data:www-data /app

RUN chmod -R 777 /app/storage bootstrap/cache

RUN apt-get install nginx -y

COPY nginx/nginx.conf /etc/nginx/sites-enabled/default

COPY entrypoint.sh /etc/entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["sh", "/etc/entrypoint.sh"]
