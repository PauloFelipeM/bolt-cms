FROM php:8.0-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    libzip-dev \
    unzip \
    libpq-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    openssh-client

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install exif pcntl bcmath gd opcache calendar gettext intl mysqli pdo_mysql shmop soap sockets sysvmsg sysvsem sysvshm zip

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u 1000 -d /home/bemove bemove
    
RUN mkdir -p /home/bemove/.composer && \
    chown -R bemove /home/bemove

# Set working directory
WORKDIR /var/www

USER bemove