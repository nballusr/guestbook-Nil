FROM php:8.0-fpm

ARG UID=1000
ARG GID=1000

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Install Yarn package manager
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

RUN apt-get update && apt-get install -y \
    wget \
    git \
    libicu-dev \
    libpq-dev \
    libxslt1-dev \
    zlib1g-dev \
    libpng-dev \
    libsodium-dev \
    libcurl4-openssl-dev \
    libzip-dev \
    librabbitmq-dev

RUN docker-php-ext-install \
    intl \
    pdo_pgsql \
    xsl \
    gd \
    sodium \
    curl \
    zip

# Install composer
COPY --from=composer/composer:2-bin /composer /usr/bin/composer

# Install Symfony CLI
RUN wget https://get.symfony.com/cli/installer -O - | bash && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

RUN php -i | grep openssl
# RUN pecl install openssl && docker-php-ext-enable openssl

RUN pecl install amqp && docker-php-ext-enable amqp
RUN pecl install redis && docker-php-ext-enable redis

RUN usermod -u $UID www-data && groupmod -g $GID www-data

WORKDIR /var/www/app

RUN chown -R www-data:www-data /var/www/app

#CMD ["php-fpm"]
