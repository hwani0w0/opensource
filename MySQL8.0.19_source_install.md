# MySQL 8.0 수동 설치
> OS : Ubuntu20.04
## 1. 필수 패키지 설치
```
$ sudo su
apt-get install cmake
apt-get install libssl-dev
apt-get install libboost-all-dev
apt-get install libncurses5-dev libncursesw5-dev
```
## 2. 소스설치
```
$ sudo su
# cd /usr/local/src
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.19.tar.gz
tar xvfz mysql-8.0.19.tar.gz
```
### 2-1. boost 설치
```
wget https://boostorg.jfrog.io/artifactory/main/release/1.70.0/source/boost_1_70_0.tar.gz
tar xvfz boost_1_70_0.tar.gz
```

## 3. 설치
```
cd mysql-8.0.19
mkdir dir_mysql (이름 아무거나 상관없음)
cd dir_mysql
# cmake \
.. \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_DATADIR=/usr/local/mysql/data \
-DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DSYSCONFDIR=/etc \
-DWITH_EXTRA_CHARSETS=all \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DDOWNLOAD_BOOST=1 \
-DWITH_BOOST=/usr/local/mysql/boost_1_70_0
# make
# make install
```
## 4. MySQL DB 초기화
### 1) mysql 그룹 및 유저 생성
```
/usr/local/mysql-8.0.19/dir_mysql# groupadd mysql
/usr/local/mysql-8.0.19/dir_mysql# useradd -r -g mysql -s /bin/false mysql
```
### 2) 디렉토리 생성
```
/usr/local# cd mysql
/usr/local/mysql# mkdir mysql-files (이름 아무거나 상관없음)
```
### 3) 권한주기
```
/usr/local/mysql# chown -R mysql:mysql /usr/local/mysql
/usr/local/mysql# chown mysql:mysql mysql-files
/usr/local/mysql# chmod 750 mysql-files
```
### 4) 기본 DB 생성
```
/usr/local/mysql# bin/mysqld --initialize --user=mysql \
--basedir=/usr/local/mysql \
--datadir=/usr/local/mysql/data
```

## 5. MySQL 서버 실행 및 비밀번호 재설정
### 1) MySQL 서버 실행
```
/usr/local/mysql# bin/mysqld_safe --user=mysql &
```
### 2) 접속 및 비밀번호 재설정
```
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'root-password';
mysql> exit
/usr/local/mysql# bin/mysqladmin -u root -p shutdown
#bin/mysql -u root -p
#Enter password: 비밀번호 입력
```
