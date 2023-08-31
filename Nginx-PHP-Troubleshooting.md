# Nginx+PHP 502 Bad Gateway

## 기본 확인 사항
1. 로그 확인 /var/logn/nginx/error.log 
2. selinux 설정 
3. 세션디렉터리 소유권한 
4. nginx, php-fpm 상태 확인

## 502 Bad Gateway 해결 절차
1. nginx 설정에서 fastcgi 버퍼 사이즈 => 12000초 충분해 보임, timeout 시간 변경 => 300초 
2. nginx 설정과 php-fpm 설정 소켓 일치 => 일치 확인
3. nginx php-fpm 재실행

### 1-1. 세부 내용 nginx 설정 경로  /etc/nginx/sites-available/default 

-  PHP handling
```
location ~ \.php$ {
           # With php7.3-fpm:
           fastcgi_split_path_info ^(.+\.php)(/.+)$;
           fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
           fastcgi_index index.php;
           fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;

          # 아래부터 버그 해결을 위해 추가해 주실 옵션입니다.
          # 502 에러를 없애기 위한 proxy 버퍼 관련 설정입니다.
          proxy_buffer_size               128k;
          proxy_buffers                   4 256k;
          proxy_busy_buffers_size         256k;

          # 502 에러를 없애기 위한 fastcgi 버퍼 관련 설정입니다.
          fastcgi_buffering               on;
          fastcgi_buffer_size             16k;
          fastcgi_buffers                 16 16k;

          # 최대 timeout 설정입니다.
          fastcgi_connect_timeout         600s;
          fastcgi_send_timeout            600s;
          fastcgi_read_timeout            600s;

          # 이 아래 설정은 PHP 성능 향상을 위한 옵션입니다. 추가해 주시면 좋습니다.
          sendfile                        on;
          tcp_nopush                      off;
          keepalive_requests              0;
```

### 2-1. nginx의 설정 안에서의 ‘fastcgi-pass’ 경로와, php-fpm 설정 파일의 listen 경로 일치
