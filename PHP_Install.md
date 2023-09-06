# PHP 7 Install
> OS:CentOS7

## php version check
```
yum list php
```

## php install
```
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm 
yum -y install epel-release yum-utils

# 원하는 버전
yum-config-manager --enable remi-php74

# 설치
yum -y install php
```

## php module
```
yum -y install php-fpm
yum -y install  php-cli  php-redis  php-brotli php-intl php-gd php-gmp php-imap php-bcmath php-interbase php-json php-mbstring php-mysqlnd php-odbc php-opcache php-memcached php-tidy php-pdo php-pdo-dblib php-pear php-pgsql php-process php-pecl-apcu php-pecl-geoip php-pecl-imagick php-pecl-hrtime php-pecl-json php-pecl-memcache php-pecl-mongodb php-pecl-rar php-pecl-pq php-pecl-redis4 php-pecl-yaml php-pecl-zip
```
