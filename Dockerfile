FROM redhat/ubi8:latest
RUN dnf module enable php:7.4 -y && dnf install httpd php php-mysqlnd php-gd php-xml php-mbstring php-json mod_ssl php-intl php-apcu -y
ADD https://releases.wikimedia.org/mediawiki/1.38/mediawiki-1.38.2.tar.gz /var/www/mediawiki.tar.gz
RUN tar -zxf /var/www/mediawiki.tar.gz --directory /var/www/ && mv /var/www/mediawiki-1.38.2 /var/www/mediawiki  && mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.backup && mkdir /run/php-fpm
COPY httpd.conf /etc/httpd/conf/httpd.conf  
COPY --chown=apache:apache LocalSettings.php /var/www/mediawiki/
COPY localhost.crt /etc/pki/tls/certs/localhost.crt
COPY localhost.key /etc/pki/tls/private/localhost.key
RUN chown -R apache:apache /var/www/mediawiki && chmod 600 /etc/pki/tls/certs/localhost.crt && php-fpm
EXPOSE 80
CMD /usr/sbin/php-fpm -D && /usr/sbin/httpd -D FOREGROUND
