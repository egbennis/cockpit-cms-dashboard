FROM php:8.1-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip

# Enable Apache modules
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy Cockpit files
COPY . /var/www/html/

# Create storage directories
RUN mkdir -p ./storage/cache ./storage/tmp ./storage/uploads ./storage/data ./storage/database \
    && chmod -R 0777 ./storage

# Configure Apache for dynamic port
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# Expose port
EXPOSE ${PORT}

# Start Apache
CMD ["apache2-foreground"]
