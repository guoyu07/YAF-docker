FROM alpine:3.5
MAINTAINER New Future <docker@newfuture.cc>

LABEL Name="YAF-docker" Description="mimimal docker image for PHP7 YAF with php-fpm"

ENV FPM_PORT=9000 \
	FPM_USER=www-data
	
# instal PHP-fpm
RUN	FPM_CONF='/etc/php7/php-fpm.conf' \
	&& FPM_PATH='/etc/php7/php-fpm.d' \
	&& PHP_INI='/etc/php7/php.ini' \
	&& PHP_CONF='/etc/php7/conf.d/' \	
	&& apk add --no-cache \
		php7-fpm \
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
		php7-session \
		# php7\		
	# config php-fpm
	&& echo -e "[global] \
		\n error_log = /proc/self/fd/2 \
		\n include = ${FPM_PATH}/*.conf "> $FPM_CONF \
	&& ADD_CONF(){ echo "$*">> $FPM_PATH/www.conf;} \
	&& ADD_CONF [www] \
	&& ADD_CONF user = $FPM_USER \
	&& ADD_CONF group = $FPM_USER \
	&& ADD_CONF listen = $FPM_PORT \
	&& ADD_CONF pm = dynamic \
	&& ADD_CONF pm.max_children = 5 \
	&& ADD_CONF pm.start_servers = 1 \
	&& ADD_CONF pm.min_spare_servers = 1 \
	&& ADD_CONF pm.max_spare_servers = 3 \
	&& ADD_CONF access.log = /proc/self/fd/2 \
	&& ADD_CONF clear_env = no \
	&& ADD_CONF catch_workers_output = yes \
	&& addgroup -g 82 -S $FPM_USER \
	&& adduser -u 82 -D -S -G $FPM_USER $FPM_USER \
	&& ln -s /usr/sbin/php-fpm7 /usr/local/bin/php-fpm \
	## config php# Set php.ini
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
	# Clean
	&& rm -rf /var/cache/apk/* \
		/var/tmp/* \
		/etc/ssl/* \
		/usr/include/* \
		/tmp/* 

#add extensions modules 
COPY modules/*.so /usr/lib/php7/modules/

EXPOSE $FPM_PORT

CMD ["/usr/sbin/php-fpm7","-F"]
