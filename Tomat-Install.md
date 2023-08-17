# Apache Tomcat 8.5
- OS : CentOS 7
    
## 1. Java install
```bash
sudo yum install java-1.8.0-openjdk -y
sudo yum install java-1.8.0-openjdk-devel -y
```
  
## 2. Tomcat install
- Apache Tomcat 버전 확인 : https://archive.apache.org/dist/tomcat/tomcat-8/
```bash
cd /usr/local/src
wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.92/bin/apache-tomcat-8.5.92.tar.gz
tar zxvf apache-tomcat-8.5.92.tar.gz
cd /usr/local
ln -s src/apache-tomcat-8.5.92 tomcat
  
# 실행
/usr/local/tomcat/bin/startup.sh
  
# 중지
/usr/local/tomcat/bin/shutdown.sh
```
