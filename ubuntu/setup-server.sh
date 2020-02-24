#!/bin/bash
## Please run this with sudo ./setup-server.sh

LC_ALL=C.UTF-8
echo 'fs.file-max = 200000' >> /etc/sysctl.conf
sysctl -p 

cd /usr/local/src

mv /etc/apt/sources.list /etc/apt/sources.list.bak
curl -o /etc/apt/sources.list https://raw.githubusercontent.com/sanjaya-solusindo/setup-server/master/ubuntu/sources.list
apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
curl -L https://nginx.org/keys/nginx_signing.key | apt-key add -

echo 'deb [arch=amd64,arm64,ppc64el] http://mirror.marwan.ma/mariadb/repo/10.4/ubuntu bionic main' > /etc/apt/sources.list.d/mariadb.list
echo 'deb-src [arch=amd64,arm64,ppc64el] http://mirror.marwan.ma/mariadb/repo/10.4/ubuntu bionic main' >> /etc/apt/sources.list.d/mariadb.list
echo 'deb http://nginx.org/packages/ubuntu/ bionic nginx' > /etc/apt/sources.list.d/nginx.list
echo 'deb-src http://nginx.org/packages/ubuntu/ bionic nginx' >> /etc/apt/sources.list.d/nginx.list
add-apt-repository -y ppa:ondrej/php
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt upgrade -y
apt install -y software-properties-common wget dpkg-dev build-essential zlib1g-dev libpcre3 libpcre3-dev unzip zip nano curl git uuid-dev debhelper po-debconf libexpat-dev libgd-dev libgeoip-dev libhiredis-dev libluajit-5.1-dev libmhash-dev libpam0g-dev libperl-dev libssl-dev libxslt1-dev quilt libxml2-dev rcs libpng-dev libwebp-dev
apt install -y mariadb-server nodejs redis-server 
apt install -y php7.4 php-http php-imagick php-mailparse php-memcache php-memcached php-mongodb php-redis php-uploadprogress php-uuid php-psr php-xdebug php7.4-bcmath php7.4-bz2 php7.4-cgi php7.4-cli php7.4-common php7.4-curl php7.4-dba php7.4-enchant php7.4-fpm php7.4-gd php7.4-gmp php7.4-imap php7.4-interbase php7.4-intl php7.4-json php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-odbc php7.4-opcache php7.4-pgsql php7.4-phpdbg php7.4-pspell php7.4-readline php7.4-snmp php7.4-soap php7.4-sqlite3 php7.4-sybase php7.4-tidy php7.4-xml php7.4-xmlrpc php7.4-xsl php7.4-zip 
sudo sed -i "s#;cgi.fix_pathinfo=1#cgi.fix_pathinfo=0#g" /etc/php/7.4/cli/php.ini

npm i -g npm
npm i -g yarn
npm i -g pm2

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"
chmod +x /usr/local/bin/composer

echo '[client]' > /etc/mysql/mariadb.conf.d/client.cnf
echo 'default-character-set = utf8' >> /etc/mysql/mariadb.conf.d/client.cnf
echo '[mysqld]' > /etc/mysql/mariadb.conf.d/mysqld.cnf
echo 'character-set-server = utf8' >> /etc/mysql/mariadb.conf.d/client.cnf
echo 'collation-server = utf8_general_ci' >> /etc/mysql/mariadb.conf.d/client.cnf
echo 'character_set_server = utf8' >> /etc/mysql/mariadb.conf.d/client.cnf
echo 'collation_server = utf8_general_ci' >> /etc/mysql/mariadb.conf.d/client.cnf
echo 'local-infile = 0' >> /etc/mysql/mariadb.conf.d/client.cnf
echo 'performance-schema = 0' >> /etc/mysql/mariadb.conf.d/client.cnf
echo 'symbolic-links = 0' >> /etc/mysql/mariadb.conf.d/client.cnf
echo 'innodb_buffer_pool_size = 134217728' >> /etc/mysql/mariadb.conf.d/client.cnf
echo 'max_allowed_packet = 268435456' >> /etc/mysql/mariadb.conf.d/client.cnf
echo 'open_files_limit = 10000' >> /etc/mysql/mariadb.conf.d/client.cnf
echo 'innodb_file_per_table = 1' >> /etc/mysql/mariadb.conf.d/client.cnf

apt source nginx -y
apt build-dep nginx -y
git clone --recursive https://github.com/google/ngx_brotli.git
git clone --recursive https://github.com/openresty/headers-more-nginx-module.git

NPS_VERSION=1.13.35.2-stable
wget https://github.com/apache/incubator-pagespeed-ngx/archive/v${NPS_VERSION}.zip
unzip v${NPS_VERSION}.zip
nps_dir=$(find . -name "*pagespeed-ngx-${NPS_VERSION}" -type d)
cd $nps_dir
NPS_RELEASE_NUMBER="${NPS_VERSION}/stable/"
psol_url=https://dl.google.com/dl/page-speed/psol/${NPS_RELEASE_NUMBER}.tar.gz
[ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
curl -O ${psol_url}
tar -xzf $(basename ${psol_url})
cd /usr/local/src/incubator-pagespeed-*/
nps_dir=$(pwd)
cd /usr/local/src/nginx-*/
sed -i "s#--with-cc-opt=#--add-module=/usr/local/src/ngx_brotli --add-module=/usr/local/src/headers-more-nginx-module --add-module=${nps_dir} --with-cc-opt=#g" debian/rules
dpkg-buildpackage -b -uc -us
cd /usr/local/src
dpkg -i *.deb
openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096
systemctl stop apache2
systemctl disable apache2
systemctl enable mariadb
systemctl enable redis-server

echo "Done!"
