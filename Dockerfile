FROM alpine:3.5
MAINTAINER New Future <docker@newfuture.cc>

LABEL Name="YAF-docker" Description="mimimal docker image for PHP7 YAF"

# Environments
ENV TIMEZONE=UTC \
	MAX_UPLOAD=50M \
	PORT=80

# instal PHP
RUN	PHP_INI='/etc/php7/php.ini' \
	&& PHP_CONF='/etc/php7/conf.d/' \	
	&& apk add --no-cache \
		# libmemcached-libs \
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
		php7\
		# php7-memcached \
		php7-session \
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
	&& ADD_EXT(){ echo "extension = ${1}.so; \\n${2}" > "$PHP_CONF/90_${1}.ini"; } \
	&& ADD_EXT redis \
	&& ADD_EXT yaf "[yaf]\\nyaf.environ = dev" \
	&& ln -s /usr/bin/php7 /usr/local/bin/php \
	# && sed -i '$ d' /etc/apk/repositories \
	# ClEAN
	&& rm -rf /var/cache/apk/* /var/tmp/* /tmp/*  /etc/ssl/* /usr/include/*

#add extensions modules 
COPY fpm/modules/*.so /usr/lib/php7/modules/

WORKDIR /newfuture/yaf

EXPOSE $PORT

CMD php7 -S 0.0.0.0:$PORT $([ ! -f index.php ]&&[ -d public ]&&echo '-t public')
