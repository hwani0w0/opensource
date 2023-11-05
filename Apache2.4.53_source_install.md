## 1. 필수 패키지 설치
> OS : Ubuntu20.04
```
$ sudo su
# apt-get update
# apt-get install make
# apt-get install build-essential
# apt-get install gcc
# apt-get install --reinstall make
# apt-get install libexpat1-dev
# apt-get install g++ 
# apt-get install net-tools
# apt-get install curl
```
## 2. 소스설치
```
$ sudo su
# cd /usr/local/src
```
1) apr-1.7.4
`/usr/local# wget https://dlcdn.apache.org//apr/apr-1.7.4.tar.gz`
2) apr-util-1.6.3
`/usr/local# wget https://dlcdn.apache.org//apr/apr-util-1.6.3.tar.gz`
3) pcre-8.43
`/usr/local# wget https://osdn.dl.osdn.net/sfnet/p/pc/pcre/pcre/8.43/pcre-8.43.tar.gz`
4) apache-2.4.58
`/usr/local# wget https://archive.apache.org/dist/httpd/httpd-2.4.58.tar.gz`

### 2-1. 압축해제
```
/usr/local# tar xvfz apr-1.7.4.tar.gz
/usr/local# tar xvfz apr-util-1.6.3.tar.gz
/usr/local# tar xvfz pcre-8.43.tar.gz
/usr/local# tar xvfz httpd-2.4.58.tar.gz
```

## 3. 설치
### 3-1. apr-util 설치
```
/usr/local# cd apr-util-1.6.3
/usr/local/apr-util-1.6.3# ./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr
/usr/local/apr-util-1.6.3# make
/usr/local/apr-util-1.6.3# make install
```
### 3-2. pcre 설치
```
/usr/local# cd pcre-8.43
/usr/local/pcre-8.43# ./configure --prefix=/usr/local/pcre
/usr/local/pcre-8.43# make
/usr/local/pcre-8.43# make install
```
### 3-3. Apache 설치 (apache-2.4.58)
```
/usr/local# ln -s httpd-2.4.58 httpd
/usr/local# cd httpd-2.4.58
/usr/local/httpd# ./configure --prefix=/usr/local/httpd \
--enable-module=so --enable-rewrite --enable-so \
--with-apr=/usr/local/apr \
--with-apr-util=/usr/local/apr-util \
--with-pcre=/usr/local/pcre/bin/pcre-config \
--enable-mods-shared=all
/usr/local/httpd# make
/usr/local/httpd# make install
```

## 4. Apache 실행
- 실행: `httpd -k start`, 종료: `httpd -k stop`
```
/usr/local# sudo httpd/bin/httpd -k start
/usr/local# ps -ef | grep httpd | grep -v grep
/usr/local# sudo netstat -anp | grep httpd
/usr/local# sudo curl http://127.0.0.1
```
### 4-1. test
- `curl http://127.0.0.1`

## 5. systemd 서비스 등록
```
vi /etc/systemd/system/apache.service

[Unit]
Description=apache
After=network.target syslog.target

[Service]
Type=forking
User=root
Group=root

ExecStart=/usr/local/httpd/bin/apachectl start
ExecStop=/usr/local/httpd/bin/apachectl stop

Umask=007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
```

