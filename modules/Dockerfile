FROM newfuture/yaf:php7

ENV TMP="/tmp/" \
    DIR="/newfuture/yaf"

WORKDIR $DIR
# VOLUME ["/home/newfuture/docker/YAF-docker/modules","$DIR"]

# RUN apk update && apk upgrade

RUN apk add --no-cache --virtual .fetch-deps \
        curl \
        autoconf \
        g++ \
        gcc \
        make \
        php7-dev\
        zlib-dev 

# RUN apk add ca-certificates

# RUN curl -#SL  https://sourceforge.net/projects/re2c/files/0.16/re2c-0.16.tar.gz | tar zx -C ./ \
#     && cd re2c-0.16 \
#     && ./configure \
#     && make \
#     && make install

RUN  BUILD(){ \
        curl -#SL http://pecl.php.net/get/$1.tgz | tar zx -C $TMP \
        && cd "$TMP/$1" && phpize7 &&./configure --with-php-config=php-config7 && make test && make install \
        && cp /$TMP/$1/modules/*.so $DIR;} \
    && BUILD yaf-3.0.4

RUN apk del .fetch-deps