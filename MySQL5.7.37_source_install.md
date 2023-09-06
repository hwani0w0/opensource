# MySQL 5.7 수동 설치
> OS : Ubuntu18.04
```
ubuntu$ wget https://downloads.mysql.com/archives/get/p/23/file/mysql-boost-5.7.31.tar.gz
ubuntu$ tar zxvf mysql-boost-5.7.31.tar.gz
ubuntu$ cd mysql-5.7.31

cmake \
'-DCMAKE_INSTALL_PREFIX=/usr/local/mysql' \
'-DINSTALL_SBINDIR=/usr/local/mysql/bin' \
'-DINSTALL_BINDIR=/usr/local/mysql/bin' \
'-DMYSQL_DATADIR=/usr/local/mysql/data' \
'-DINSTALL_SCRIPTDIR=/usr/local/mysql/bin' \
'-DWITH_INNOBASE_STORAGE_ENGINE=1' \
'-DWITH_PARTITION_STORAGE_ENGINE=1' \
'-DSYSCONFDIR=/usr/local/mysql/etc' \
'-DDEFAULT_CHARSET=utf8mb4' \
'-DDEFAULT_COLLATION=utf8mb4_general_ci' \
'-DWITH_EXTRA_CHARSETS=all' \
'-DENABLED_LOCAL_INFILE=1' \
'-DMYSQL_TCP_PORT=3306' \
'-DMYSQL_UNIX_ADDR=/tmp/mysql.sock' \
'-DCURSES_LIBRARY=/usr/lib/x86_64-linux-gnu/libncurses.so' \
'-DCURSES_INCLUDE_PATH=/usr/include' \
'-DDOWNLOAD_BOOST=1' \
'-DWITH_BOOST=./boost' \
'-DWITH_ARCHIVE_STORAGE_ENGINE=1' \
'-DWITH_BLACKHOLE_STORAGE_ENGINE=1' \
'-DWITH_PERFSCHEMA_STORAGE_ENGINE=1' \
'-DWITH_FEDERATED_STORAGE_ENGINE=1'

make && make install
```
- 권한
```
groupadd mysql
useradd -r -g mysql -s /bin/false mysql
chown -R mysql.mysql /usr/local/mysql
```

- my-default.ini 없음 새로 만들어줘야함
```
vi /etc/my.cnf

[client]
port = 3306
socket = /tmp/mysql.sock

[mysql]
no-auto-rehash
show-warnings
prompt=\u@\h:\d_\R:\m:\\s>
pager="less -n -i -F -X -E"

[mysqld]
server-id=1
port = 3306
bind-address = 0.0.0.0
basedir = /usr/local/mysql
datadir= /usr/local/mysql/data
tmpdir=/usr/local/mysql/data
socket=/tmp/mysql.sock
user=mysql
skip_name_resolve
#timestamp
explicit_defaults_for_timestamp = TRUE

### MyISAM Spectific options
key_buffer_size = 100M

### INNODB Spectific options
default-storage-engine = InnoDB
innodb_buffer_pool_size = 384M

#User Table Datafile
innodb_data_home_dir = /usr/local/mysql/data/
innodb_data_file_path = ib_system:100M:autoextend
innodb_file_per_table=ON
innodb_log_buffer_size = 8M
innodb_log_files_in_group = 3
innodb_log_file_size=200M
innodb_log_files_in_group=4
#innodb_log_group_home_dir = /usr/local/mysql/data/redologs
#innodb_undo_directory = /usr/local/mysql/data/undologs
innodb_undo_tablespaces = 1

### Connection
back_log = 100
max_connections = 1000
max_connect_errors = 1000
wait_timeout= 60
pROF?P/2u/)>
### log
# Error Log
log_error=/usr/local/mysql/logs/mysqld.err
log-output=FILE
general_log=0
slow-query-log=0
long_query_time = 5
# 5 sec
slow_query_log_file = /usr/local/mysql/logs/slow_query.log
pid-file=/usr/local/mysql/tmp/mysqld.pid

###chracterset
character-set-client-handshake=OFF
skip-character-set-client-handshake
character-set-server = utf8mb4
collation-server = utf8mb4_general_ci

[mysqld_safe]
log_error=/usr/local/mysql/logs/mysqld.err
pid-file=/usr/local/mysql/tmp/mysqld.pid
```

- 실행
```
/usr/local/mysql/bin/mysqld_safe --user=mysql &
/usr/local/mysql/bin/mysqladmin -u root password "wins"

vi /usr/local/mysql/support-files/mysql.server
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/

systemctl daemon-reload
systemctl restart mysql
```
