# MySQL 5.7 Install
> OS: CentOS 7

# GPG
```bash
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

sudo yum -y install http://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum -y install mysql-community-server
```

# Start
```
systemctl enable mysqld
systemctl start mysqld
```
- 최초 패스워드 ` /var/log/mysqld.log `
- 패스워드 변경
```
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Wkawhawkwk123!';
FLUSH PRIVILEGES;
```

# Conf
- /etc/my.cnf
```
[client]
default-character-set = utf8

[mysql]
default-character-set=utf8

[mysqldump]
default-character-set=utf8

[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

character-set-server=utf8
collation-server=utf8_general_ci
init_connect=SET collation_connection = utf8_general_ci
init_connect=SET NAMES utf8

character-set-client-handshake = FALSE
skip-character-set-client-handshake

symbolic-links=0

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
```
