## MySQL Replication 

- version : 5.7
- OS : ubuntu 18.04
   
### Backup & Restore
+ 데이터 무결성
```bash
# dump backup
mysqldump -uroot -p -A -R -E --all-databases > testdump.sql
   
# dump restore
mysql -uroot -p < testdump.sql
```

### Master DB 
+ conf 변경
```bash
# vim /etc/my.cnf
server-id= 1
log-bin=mysql-bin
binlog_format=mixed
   
# systemctl restart mysql
```
+ SQL 변경
```mysql
> create user 'repli'@'{Slave DB IP}' identified by '{password};
> grant replication slave on *.* to 'repli'@'{Slave DB IP}' identified by '{password}';
> flush tables with read lock;
```
      
### Slave DB
+ conf 변경
```bash
# vim /etc/my.cnf
server-id= 2
log-bin=mysql-bin
binlog_format=mixed
   
# systemctl restart mysql
```
+ SQL 변경
```mysql
> stop slave;
> change master to
   master_host='{Master DB IP}',
   master_user='repli',
   master_password='{password}',
   master_port={Master DB port},
   master_log_file='{file name}',
   master_log_pos={position num},
   master_connect_retry=10;
> start slave;
```
   
### Replication Check
```mysql
# slave 동작 확인
> show slave status\G

# master 동작 확인
> unlock tables;
> show processlist\G
```
   
