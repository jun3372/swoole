FROM php:7.2-alpine

LABEL maintainer="Jun <zhoujun3372@gmail.com>"

# 安装依赖
RUN apk add .build-deps \
    g++ \
    vim \
    wget \
    make \
    tzdata \
    hiredis \
    autoconf \
    curl-dev \
    libpng-dev \
    gettext-dev \
    freetype-dev \
    libmcrypt-dev \
    cyrus-sasl-dev \
    libmemcached-dev \
    libjpeg-turbo-dev  
    


# 安装GD库
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# 安装PHP扩展
RUN docker-php-ext-install -j$(nproc) gd iconv gettext curl mysqli pdo pdo_mysql zip mbstring bcmath opcache xml simplexml sockets hash soap exif

# 安装扩展
# Redis
RUN pecl install redis && docker-php-ext-enable redis
# Memcached
RUN pecl install memcached && docker-php-ext-enable memcached
# Swoole
RUN pecl install swoole && docker-php-ext-enable swoole

# 安装Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer self-update --clean-backups 

# 设置上海时区
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  && echo "Asia/Shanghai" >  /etc/timezone

# 清理缓存
RUN apk del .build-deps
RUN rm -rf /var/cache/apk/*
RUN pecl clear-cache

# 暴露端口
EXPOSE 80
