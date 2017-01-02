FROM alpine:3.5

ENV TMP="/tmp/" \
    DIR="/newfuture/yaf"

WORKDIR $DIR
VOLUME ["/home/newfuture/docker/YAF-docker/modules","$DIR"]


RUN apk update && apk upgrade

RUN apk add \
        curl \
        autoconf \
        pkgconf \
        file \
        g++ \
        gcc \
        make \
        zlib-dev \
        re2c

RUN apk add \
        php7 \
        php7-dev \
        php7-session

# RUN apk add ca-certificates

# RUN curl -#SL  https://sourceforge.net/projects/re2c/files/0.16/re2c-0.16.tar.gz | tar zx -C ./ \
#     && cd re2c-0.16 \
#     && ./configure \
#     && make \
#     && make install

RUN  BUILD(){ \
        curl -#SL https://pecl.php.net/get/$1.tgz | tar zx -C $TMP \
        && cd "$TMP/$1" && phpize7 &&./configure --with-php-config=php-config7 && make test && make install \
        && cp /$TMP/$1/modules/*.so $DIR;} \
    && BUILD yaf-3.0.4 \
    && BUILD redis-3.1.0

# RUN apk del .fetch-deps
