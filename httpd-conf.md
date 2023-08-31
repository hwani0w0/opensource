# Apache httpd 2.4

## 설치
```bash
yum update
yum -y install httpd
```

## conf 파일
- 로그설정 및 was 연동 
  - **httpd-vhost.conf**
```vi
<VirtualHost *:80>
  ServerName {domain url}
  DocumentRoot /var/www/html

  CustomLog "|/sbin/rotatelogs logs/swc.access_log.%Y%m%d 86400" combined
  ErrorLog  "|/sbin/rotatelogs logs/swc.error_log.%Y%m%d 86400"

  #JkMount /* worker1
  ProxyRequests off
  ProxyPreserveHost On
  ProxyPass / http://{was ip}:8080/ acquire=3000 timeout=600 Keepalive=On
  ProxyPassReverse / http://{was ip}:8080/

  RewriteEngine On
  RewriteCond %{HTTPS} !on
  RewriteRule ^(.*)$ https://%{HTTP_HOST}$1 [R,L]

</VirtualHost>
```
- ssl 인증서 적용
  - **httpd-ssl.conf**
```
Listen 443

<VirtualHost *:443>
  ServerName {domain url}:443
  DocumentRoot /var/www/html

  #JkMount /* worker1
  ProxyRequests off
  ProxyPreserveHost On
  ProxyPass / http://{was ip}:8080/ acquire=3000 timeout=600 Keepalive=On
  ProxyPassReverse / http://{was ip}:8080/

  CustomLog "|/sbin/rotatelogs logs/swc.ssl_access_log.%Y%m%d 86400" combined
  ErrorLog  "|/sbin/rotatelogs logs/swc.ssl_error_log.%Y%m%d 86400"

  SSLCertificateFile "/etc/httpd/ssl/cert_~~~.crt"
  SSLCertificateKeyFile "/etc/httpd/ssl/prv_~~.no_pass.key"
  SSLCertificateChainFile "/etc/httpd/ssl/subca1_~~.crt"
  SSLCACertificateFile "/etc/httpd/ssl/rootca_~~.crt"

  SSLEngine on
  SSLProtocol -all +TLSv1 +TLSv1.1 +TLSv1.2
  SSLCipherSuite HIGH:3DES:!aNULL:!MD5:!SEED:!IDEA

</VirtualHost>
```

## 인증서 암호 제거
``` bash
yum -y install openssl
yum -y install mod_ssl

# key 암호 제거
openssl rsa -in ~.key -out ~.key
```
