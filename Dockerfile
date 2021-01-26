FROM localregistry:5000/centos:7.9.2009

ENV http_proxy="http://193.56.47.20:8080"
ENV https_proxy="http://193.56.47.20:8080"
ENV LD_LIBRARY_PATH=/usr/lib/oracle/12.2/client64/lib

HEALTHCHECK CMD curl -s http://localhost >/dev/null || exit 1

EXPOSE 80
EXPOSE 443

COPY entrypoint.sh /

RUN \
yum -y update && \
yum -y install epel-release.noarch && \
yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
yum makecache && \
yum -y install httpd.x86_64 httpd-devel.x86_64 httpd-tools.x86_64 php.x86_64 php-common.x86_64 php-cli.x86_64 php-bcmath.x86_64 php-gd.x86_64 php-pdo.x86_64php-xml.x86_64 epel-release.noarch php-pgsql php-pdo php-common php-gd php-process php php-pdo php-cli php-mssql php-pecl-oci8 php-pear php-pecl-ssh2 php-xml php-devel wget libaio.x86_64 curl mod_ssl && \
sed -i 's/^\(SSLCertificateFile\).*$/\1 \/run\/secrets\/server.crt/' /etc/httpd/conf.d/ssl.conf && \
sed -i 's/^\(SSLCertificateKeyFile\).*$/\1 \/run\/secrets\/server.key/' /etc/httpd/conf.d/ssl.conf && \
mkdir -p /var/www/html/icm && mkdir -p /export/home/psc

RUN mkdir /instantclient
WORKDIR /instantclient
COPY oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm .
COPY oracle-instantclient12.2-sqlplus-12.2.0.1.0-1.x86_64.rpm .
COPY oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm .
COPY oracle-instantclient12.2-tools-12.2.0.1.0-1.x86_64.rpm .
COPY oracle-instantclient12.2-odbc-12.2.0.1.0-2.x86_64.rpm .
RUN rpm -Uvh oracle-instantclient12.2*

COPY php.ini /etc/php.ini

WORKDIR /

CMD ["/bin/bash"]

ENTRYPOINT ["/entrypoint.sh"]

