#!/bin/bash

sudo cd /usr/local/src

sudo curl -o sources.list https://raw.githubusercontent.com/sanjaya-solusindo/setup-server/master/ubuntu/sources.list
sudo cat sources.list > /etc/apt/sources.list
sudo timedatectl set-timezone Asia/Jakarta
sudo apt install software-properties-common
sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
sudo echo 'deb [arch=amd64,arm64,ppc64el] http://mirror.marwan.ma/mariadb/repo/10.4/ubuntu bionic main' > /etc/apt/sources.list.d/mariadb.list
sudo echo 'deb-src [arch=amd64,arm64,ppc64el] http://mirror.marwan.ma/mariadb/repo/10.4/ubuntu bionic main' >> /etc/apt/sources.list.d/mariadb.list
sudo echo 'deb http://nginx.org/packages/ubuntu/ bionic nginx' > /etc/apt/sources.list.d/nginx.list
sudo echo 'deb-src http://nginx.org/packages/ubuntu/ bionic nginx' >> /etc/apt/sources.list.d/nginx.list
sudo curl -L https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt upgrade -y
sudo apt install -y dpkg-dev build-essential zlib1g-dev libpcre3 libpcre3-dev unzip zip nano curl git uuid-dev debhelper po-debconf libexpat-dev libgd-dev libgeoip-dev libhiredis-dev libluajit-5.1-dev libmhash-dev libpam0g-dev libperl-dev libssl-dev libxslt1-dev quilt libxml2-dev rcs libpng-dev libwebp-dev
sudo apt install -y mariadb-server nodejs redis-server php7.4
sudo apt install -y php-http php-imagick php-mailparse php-memcache php-memcached php-mongodb php-redis php-uploadprogress php-uuid php-psr php-xdebug php7.4-bcmath php7.4-bz2 php7.4-cgi php7.4-cli php7.4-common php7.4-curl php7.4-dba php7.4-enchant php7.4-fpm php7.4-gd php7.4-gmp php7.4-imap php7.4-interbase php7.4-intl php7.4-json php7.4-ldap php7.4-mbstring php7.4-mysql php7.4-odbc php7.4-opcache php7.4-pgsql php7.4-phpdbg php7.4-pspell php7.4-readline php7.4-snmp php7.4-soap php7.4-sqlite3 php7.4-sybase php7.4-tidy php7.4-xml php7.4-xmlrpc php7.4-xsl php7.4-zip 

sudo npm i -g npm
sudo npm i -g yarn
sudo npm i -g pm2

sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo php -r "unlink('composer-setup.php');"
sudo chmod +x /usr/local/bin/composer

sudo echo '[client]' > /etc/myclass/mariadb.conf.d/client.cnf
sudo echo 'default-character-set = utf8' >> /etc/myclass/mariadb.conf.d/client.cnf
sudo echo '[mysqld]' > /etc/myclass/mariadb.conf.d/mysqld.cnf
sudo echo 'character-set-server = utf8' >> /etc/myclass/mariadb.conf.d/client.cnf
sudo echo 'collation-server = utf8_general_ci' >> /etc/myclass/mariadb.conf.d/client.cnf
sudo echo 'character_set_server = utf8' >> /etc/myclass/mariadb.conf.d/client.cnf
sudo echo 'collation_server = utf8_general_ci' >> /etc/myclass/mariadb.conf.d/client.cnf
sudo echo 'local-infile = 0' >> /etc/myclass/mariadb.conf.d/client.cnf
sudo echo 'performance-schema = 0' >> /etc/myclass/mariadb.conf.d/client.cnf
sudo echo 'symbolic-links = 0' >> /etc/myclass/mariadb.conf.d/client.cnf
sudo echo 'innodb_buffer_pool_size = 134217728' >> /etc/myclass/mariadb.conf.d/client.cnf
sudo echo 'max_allowed_packet = 268435456' >> /etc/myclass/mariadb.conf.d/client.cnf
sudo echo 'open_files_limit = 10000' >> /etc/myclass/mariadb.conf.d/client.cnf
sudo echo 'innodb_file_per_table = 1' >> /etc/myclass/mariadb.conf.d/client.cnf

sudo apt source nginx -y
sudo apt build-dep nginx -y
sudo git clone --recursive https://github.com/google/ngx_brotli.git
sudo git clone --recursive https://github.com/openresty/headers-more-nginx-module.git

NPS_VERSION=1.13.35.2-stable
sudo wget https://github.com/apache/incubator-pagespeed-ngx/archive/v${NPS_VERSION}.zip
sudo unzip v${NPS_VERSION}.zip
nps_dir=$(find . -name "*pagespeed-ngx-${NPS_VERSION}" -type d)
sudo cd "$nps_dir"
NPS_RELEASE_NUMBER="${NPS_VERSION}/stable/"
psol_url=https://dl.google.com/dl/page-speed/psol/${NPS_RELEASE_NUMBER}.tar.gz
[ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
sudo wget ${psol_url}
sudo tar -xzvf $(basename ${psol_url})  # extracts to psol/
sudo cd /usr/local/src/incubator-pagespeed-*/
NPS_DIR=$(pwd)
sudo cd /usr/local/src/nginx-*/
sudo sed -i "s#--with-cc-opt=#--add-module=/usr/local/src/ngx_brotli --add-module=/usr/local/src/headers-more-nginx-module --add-module=${NPS_DIR} --with-cc-opt=#g" debian/rules
sudo dpkg-buildpackage -b -uc -us -y
sudo cd /usr/local/src/
sudo dpkg -i *.deb

openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096

sudo systemctl stop apache2
sudo systemctl disable apache2
sudo systemctl enable mariadb
sudo systemctl enable redis-server
sudo reboot
