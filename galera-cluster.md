# Cluster 구성


## 1. Node 설정

- 
```bash
[galera]
wsrep_on=ON
wsrep_provider=/usr/lib64/galera-4/libgalera_smm.so

wsrep_node_name='galera1'
wsrep_node_address="10.0.1.40"

wsrep_cluster_name='galera-training'
wsrep_cluster_address="gcomm://10.0.1.40,10.0.1.198,10.0.1.216"

wsrep_provider_options="gcache.size=300M; gcache.page_size=300M"
wsrep_slave_threads=4
wsrep_sst_method=rsync
```

```bash
semanage port -a -t mysqld_port_t -p tcp 3306
semanage port -a -t mysqld_port_t -p tcp 4444
semanage port -a -t mysqld_port_t -p tcp 4567
semanage port -a -t mysqld_port_t -p udp 4567
semanage port -a -t mysqld_port_t -p tcp 4568
semanage permissive -a mysqld_t
```

```bash
systemctl enable firewalld
systemctl start firewalld

firewall-cmd --zone=public --add-service=mysql --permanent
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --zone=public --add-port=4444/tcp --permanent
firewall-cmd --zone=public --add-port=4567/tcp --permanent
firewall-cmd --zone=public --add-port=4567/udp --permanent
firewall-cmd --zone=public --add-port=4568/tcp --permanent

firewall-cmd --reload
```

A.	첫번째 Node
i.	# mysqld --wsrep-new-cluster
ii.	# galera_new_cluster
(Galera-4버전 mariaDB 10.4 경우)
B.	그 외 Node
i.	# mysql -p -u root -e "SHOW STATUS LIKE 'wsrep_cluster_size'"
