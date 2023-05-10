## Environment
+ OS : Ubuntu 18.04

## Proxy Server
+ 인터넷 통신이 가능한 Public 영역에 위치
```bash
apt update
apt install squid
   
systemctl status squid
   
vim /etc/squid/squid.conf
```

```bash
# /etc/squid/squid.conf
   
# should be allowed
acl localnet src 10.0.0.0/8   # Client Network 대역
acl localnet src fc00::/7
acl localnet src fc800::/10
   
# Squid normally listens to port 3128
http_port IP_ADDR:PORT
   
# Only allow cachemgr access from localhost
http_access allow localnet
http_access allow localhost manager
http_access deny manager
   
# 허용 Port 입력
acl SSL_ports port 443
(중략)
   
# acl 상세 설정 시...
acl allowed_ips  src "/etc/squid/allowed_ips.txt"
```
+ http_access 규칙의 순서가 중요
+ http_access denied all을(를) 모두 거부하기 전에 줄을 추가
+ Squid는 규칙을 위에서 아래로 읽으며 규칙이 아래 규칙과 일치하면 처리되지 않음

```bash
systemctl restart squid
systemctl status squid
   
ufw allow 'Squid'
# or
ufw disable
```

## Client Server
+ 인터넷 통신이 불가한 Private 영역에 위치
```bash
# vim /etc/bash.bashrc
export http_proxy="{Proxy IP}:{Proxy Port}"
export https_proxy="{Proxy IP}:{Proxy Port}"
export ftp_proxy="{Proxy IP}:{Proxy Port}"
   
# vim /etc/apt/apt.conf
Acquire::http::proxy "http://{Proxy IP}:{Proxy Port}";
Acquire::https::proxy "https://{Proxy IP}:{Proxy Port}";
```

+ `curl` `apt-get` 명령어 수행


## Tip
+ apt error 발생 시 `vim /etc/apt/sources.list` 주소 확인
+ vim 편집기 색인일괄교체 명령어 `:%s/{찾는 단어}/{교체 단어}/g`
   
