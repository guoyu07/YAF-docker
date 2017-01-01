FROM alpine:3.5
MAINTAINER New Future <docker@newfuture.cc>

LABEL Name="YAF-docker" Description="mimimal docker image for PHP7 YAF"

# Environments
ENV TIMEZONE=UTC \
	PHP_MEMORY_LIMIT=512M \
	MAX_UPLOAD=50M \
	PHP_INI=/etc/php7/php.ini \
	PORT=80

# instal PHP
RUN	echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
	&& apk add --no-cache \
		libmemcached-libs \
	#php and ext
		php7-mcrypt \
		php7-openssl \
        php7-curl \
		php7-json \
		php7-dom \
		php7-bcmath \
		php7-gd \
        php7-pdo \
		php7-pdo_mysql \
		php7-pdo_sqlite \
        php7-pdo_odbc \
    	php7-pdo_dblib \
		php7-gettext \
		php7-iconv \
		php7-ctype \
		php7-phar \
		php7\
		php7-memcached \
		php7-redis \
    # Set php.ini
    && CHANGE_INI(){ \
        if [ $(cat ${PHP_INI} | grep -c "^\s*$1") -eq 0 ] ;\
        then echo "$1=$2" >> ${PHP_INI} ;\ 
        else sed -i "s/^\s*$1.*$/$1=$2/" ${PHP_INI}; fi; } \
	&& CHANGE_INI date.timezone ${TIMEZONE} \
	&& CHANGE_INI upload_max_filesize ${MAX_UPLOAD} \
	&& CHANGE_INI cgi.fix_pathinfo 0 \
	&& CHANGE_INI display_errors 1 \
	&& CHANGE_INI display_startup_errors 1 \
	&& CHANGE_INI zend.assertions 0 \
	&& ADD_INI(){ echo "$*">> $PHP_INI; } \
	&& ADD_INI [yaf] \
	&& ADD_INI extension = yaf.so \	
	&& ADD_INI yaf.environ = dev \
	&& ln -s /usr/bin/php7 /usr/bin/php \
	&& sed -i '$ d' /etc/apk/repositories \
	# ClEAN
	&& rm -rf /var/cache/apk/* /var/tmp/* /tmp/*  /etc/ssl/* /usr/include/*

#add extensions modules 
COPY modules/ /usr/lib/php7/modules/

WORKDIR /newfuture/yaf

EXPOSE $PORT

CMD php -S 0.0.0.0:$PORT $([ ! -f index.php ]&&[ -d public ]&&echo '-t public')
