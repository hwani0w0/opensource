#!/bin/bash

######################################
# KT Cloud D1 Zone VM Inital Setting #
######################################

set +o history

# UTC to KST Converter
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Locale Change
localectl set-locale "LANG=ko_KR.utf8"
echo "LANG=ko_KR.utf8" >> /etc/profile
source /etc/profile

# History Time Logging
echo "HISTTIMEFORMAT=\"[%Y-%m-%d_%H:%M:%S]  \"" >> /etc/profile
source /etc/profile


# Selinux Disable
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config


# Firewalld Disable
systemctl stop firewalld && systemctl disable firewalld


# SSH Password Login
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config                         #root 접속 차단
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config         #패스워드로그인
sed -i '/PasswordAuthentication no/ s/^/#/' /etc/ssh/sshd_config                                #공개키인증해제
sed -i '/GSSAPIAuthentication yes/ s/^/#/' /etc/ssh/sshd_config                                 #Kerberos인증해제
systemctl restart sshd


# Network Tool Install
yum install iputils net-tools tcpdump -y


# NTP Server Configuration
yum install ntp ntpdate -y
#sed -i '/iburst/ s/^/#/g' /etc/ntp.conf                                                        #default server 사용안함
sed -i'' -r -e "/Hosts/a\restrict 172.25.0.0 mask 255.255.255.0 nomodify notrap" /etc/ntp.conf  #DMZ_Tier접속허용
sed -i'' -r -e "/Hosts/a\restrict 172.25.1.0 mask 255.255.255.0 nomodify notrap" /etc/ntp.conf  #Priv_Tier접속허용
systemctl restart ntpd && systemctl enable ntpd                                                 #NTP적용
echo "00 1 * * * root ntpdate time.bora.net" >> /etc/crontab                                    #시간동기화1
echo "00 1 * * * root ntpdate kr.pool.ntp.org" >> /etc/crontab                                  #시간동기화2
systemctl restart crond                                                                         #crontab적용


# NTP Client Configuration
#yum install ntp ntpdate -y
#systemctl stop ntpd
#sed -i '/time.bora.net/ s/^/#/g' /etc/ntp.conf
#sed -i '/kr.pool.ntp.org/ s/^/#/g' /etc/ntp.conf
#sed -i'' -r -e "/joining/a\server {NTP Server IP} iburst" /etc/ntp.conf
#ntpdate  {NTP Server IP}
#systemctl start ntpd && systemctl enable ntpd
#echo "00 1 * * * root ntpdate {NTP Server IP}" >> /etc/crontab
#systemctl restart crond


# Password Change
echo '{Password}' | passwd --stdin root
echo '{Password}' | passwd --stdin centos


# Session Timeout
#echo "TMOUT=300" >> /etc/profile
#source /etc/profile


set -o history

