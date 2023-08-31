# php 7.4.1
> OS : Ubuntu 18.04
 
## Default
- php releases : https://www.php.net/releases/index.php

## 의존성 패키지
```
apt-get install -y libxml2-dev libssl-dev \
libjpeg-dev libpng-dev \
libsqlite3-dev pkg-config
```
 
## apt 설치
```
apt-get install php-common* php7.4-cli* php7.4-common* php7.4-curl* php7.4-gd* php7.4-intl* php7.4-json* php7.4-mbstring* php7.4-mysql* php7.4-opcache* php7.4-readline*  php7.4-soap* php7.4-xml* php7.4-xmlrpc* php7.4-xsl* php7.4-zip* -y
```
- php bit 체크
```
<?
if(PHP_INT_MAX == 2147483647)
    echo '32-bit';
else
    echo '64-bit';
?>
```


## 수동 설치
### PHP tar.gz 다운로드
```
cd /usr/local/src

wget https://www.php.net/distributions/php-7.4.1.tar.gz
tar zxf php-7.4.1.tar.gz
```
 

### 설치
```
cd php-7.4.1/

./configure \
--with-apxs2=/usr/local/apache2/bin/apxs \
--with-config-file-path=/etc/php/7.4/cli/ \
--enable-calendar \
--enable-ftp \
--with-jpeg \
--with-zlib \
--enable-exif \
--enable-mbstring \
--with-curl=/usr/bin/curl \
--enable-mysqlnd \
--with-mysql-sock=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-imap-ssl \
--with-iconv \
--enable-gd \
--with-libxml \
--with-openssl

make clean
make && make install

```
- make 완료 후 apache httpd 재실행 필요
  
### apache php 연동
```
# vi /usr/local/httpd/conf/httpd.conf

LoadModule php7_module        modules/libphp7.so

# 추가
    AddType application/x-httpd-php .php .htm .html .inc
    AddType application/x-httpd-php-source .phps
```

### php.ini 파일 세팅
```
cd /data/php-7.4.1
cp php.ini-production /usr/local/lib/php.ini
```
### 테스트 php 작성
```
echo "<?php echo phpinfo(); ?>" > phpinfo.php
```
- 접속 확인

## ETC
- php-fpm 평균 메모리사용량 구하는 법
```
ps -e | grep php
ps --no-headers -o "rss,cmd" -C php-fpm7.4 | awk '{ sum+=$1 } END { printf ("%d%s\n", sum/NR/1024,"M") }'
```
- php 모듈 설치시 ts / nts 모드 확인 필요
- H사 최종 configure
```
apt update
apt install libonig-dev
apt-get install libcurl4-openssl-dev
apt-get install pkg-config
apt install libxml2-dev libjpeg-dev libpng-dev libsqlite3-dev

./configure \
--with-apxs2=/usr/local/apache2/bin/apxs \
--with-config-file-path=/etc/php/7.4/cli/ \
--with-config-file-scan-dir=/etc/php/7.4/cli/conf.d \
--enable-calendar \
--enable-ftp \
--with-jpeg \
--with-zlib \
--enable-exif \
--enable-mbstring \
--with-curl=/usr/bin/curl \
--enable-mysqlnd \
--with-mysql-sock=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-imap-ssl \
--with-iconv \
--enable-gd \
--with-libxml \
--with-openssl

make clean && make && make install
```

