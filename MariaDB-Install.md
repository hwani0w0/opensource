# Mariadb 10.5 installed in CentOS 7

1. yum repository 등록
```bash
curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
sudo bash mariadb_repo_setup --mariadb-server-version=10.5
sudo yum makecache -y
sudo yum repolist
```
　   
   
2. yum install
- 최초 설치시 `mysql`로 root 로그인 가능
```bash
sudo yum install MariaDB-server MariaDB-client MariaDB-backup
sudo systemctl enable mariadb && sudo systemctl start mariadb
```
　   
   
3. datadir 변경
- 기본 datadir 확인
```mysql
MariaDB [(none)]> select @@datadir;
+-----------------+
| @@datadir       |
+-----------------+
| /var/lib/mysql/ |
+-----------------+
```
- datadir 복사 및 DB 정지
```bash
sudo rsync -av /var/lib/mysql/ /data/mysql/
sudo systemctl stop mysql
```
- `/etc/my.cnf` 변경
```vim
[mysqld]
datadir=/data/mysql
socket=/data/mysql/mysql.sock
   
[client]
socket=/data/mysql/mysql.sock
```
- DB 재기동
```bash
sudo systemctl start mysql
```
- 변경된 datadir 확인
```mysql
MariaDB [(none)]> select @@datadir;
+--------------+
| @@datadir    |
+--------------+
| /data/mysql/ |
+--------------+
```
