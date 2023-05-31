### MySQL Replication 

+ version : 5.7
+ OS : ubuntu 18.04

```bash
# dump backup
mysqldump -uroot -p -A -R -E --all-databases > testdump.sql
   
# dump restore
mysql -uroot -p < testdump.sql
```



+ 
```
show master status;

# vi /etc/my.cnf
server-id       = 1
log-bin=mysql-bin
binlog_format=mixed

mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'{Slave DB IP}' IDENTIFIED BY '{password}';
mysql> FLUSH TABLES WITH READ LOCK;
unlock tables;
```
   
   
+ slave 설정
```mysql
stop slave;
   
change master to
master_host='{Master DB IP}',
master_user='repli',
master_password='{password}',
master_port={Master DB port},
master_log_file='{file name}',
master_log_pos={position num},
master_connect_retry=10;
   
start slave;
```

```mysql
# slave 동작 확인
show slave status\G

# master 동작 확인
show processlist\G
```


