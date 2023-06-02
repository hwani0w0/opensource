## 1. Repository 파일 생성
+ 설치하고자 하는 MySQL 버전에 따라 Galera 설치
+ 다운로드 경로 https://galeracluster.com/downloads/
+ Galera 3 – MySQL 5.5, 5.6, 5.7
+ Galera 4 – MySQL 8.0

```bash
# vi /etc/yum.repos.d/galera.repo
[galera]
name = Galera
baseurl = http://releases.galeracluster.com/galera-3/centos/7/x86_64
gpgkey = http://releases.galeracluster.com/GPG-KEY-galeracluster.com
gpgcheck = 1
[mysql-wsrep]
name = MySQL-wsrep
baseurl = http://releases.galeracluster.com/mysql-wsrep-5.6/centos/7/x86_64/
gpgkey = http://releases.galeracluster.com/GPG-KEY-galeracluster.com
gpgcheck = 1
```

```bash
# yum –y update
# yum –y install galera-3 mysql-wsrep-5.6
# systemctl start mysql && systemctl status mysql
# cat /root/.mysql_secret
( MySQL5.7경우 # grep 'temporary password' /var/log/mysqld.log )
# mysql_secure_installation
(설정 이후 DB 접속)
# mysql –u root -p

```

```bash
systemctl enable firewalld
systemctl start firewalld

firewall-cmd --zone=public --add-service=mysql --permanent
firewall-cmd --zone=public --add-port=3306/tcp —permanent
firewall-cmd --zone=public --add-port=4444/tcp --permanent
firewall-cmd --zone=public --add-port=4567/tcp --permanent
firewall-cmd --zone=public --add-port=4567/udp --permanent
firewall-cmd --zone=public --add-port=4568/tcp --permanent
firewall-cmd --reload
```

```bash
# setenforce 0

semanage port -a -t mysqld_port_t -p tcp 3306
semanage port -a -t mysqld_port_t -p tcp 4444
semanage port -a -t mysqld_port_t -p tcp 4567
semanage port -a -t mysqld_port_t -p udp 4567
semanage port -a -t mysqld_port_t -p tcp 4568
semanage permissive -a mysqld_t
```


```bash
# vim /etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
user=mysql
binlog_format=ROW
bind-address=0.0.0.0
default_storage_engine=innodb
innodb_autoinc_lock_mode=2
innodb_flush_log_at_trx_commit=0
innodb_buffer_pool_size=122M
wsrep_provider=/usr/lib64/galera-3/libgalera_smm.so
wsrep_on = ON
wsrep_cluster_name="mysql galera"
wsrep_cluster_address="gcomm://10.0.1.215,10.0.1.143,10.0.1.52"
wsrep_sst_method=rsync
wsrep_node_address="10.0.1.215"
wsrep_node_name="node-01"
wsrep_debug=ON
wsrep_log_conflicts=ON
```
```bash
# find / -name libgalera_smm.so
```

```bash
# systemctl stop mysql  && systemctl status mysql
# mysql_install_db (DB 초기화 명령어, 선택 사항)
```

|DB Version|Seed Node|Additional Node|
|------|---|---|
|MySQL 5.6 이하|# mysqld --wsrep-new-cluster|# systemctl start mysqld|
|MySQL 5.7 이상|# mysqld_bootstrap|# systemctl start mysql|
|MariaDB 10.4 이상|# galear_new_cluster|# systemctl start mariadb|

