#!/bin/sh

# OS:Ubuntu 20.04

# Env Conf
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime
sudo hostnamectl set-hostname jenkins

sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i '/PasswordAuthentication no/ s/^/#/' /etc/ssh/sshd_config
sudo sed -i '/GSSAPIAuthentication yes/ s/^/#/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# AWS CLI install
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
sudo unzip awscliv2.zip
sudo ./aws/install
export PATH=/usr/local/bin:$PATH
source ~/.bash_profile

access_key="{aws user access key}"
secret_access_key="{aws user secret access key}"
region="ap-northeast-2"

aws configure << EOF
${access_key}
${secret_access_key}
${region}
json
EOF

# Docker install
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

sudo systemctl enable docker

# jenkins install
sudo apt-get install openjdk-11-jdk -y
#wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key |sudo gpg --dearmor -o /usr/share/keyrings/jenkins.gpg
#sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins.gpg] http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
#sudo apt-key adv --keyserver  keyserver.ubuntu.com --recv-keys 5BA31D57EF5975CA
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install jenkins -y

sudo systemctl enable jenkins
sudo systemctl start jenkins

#sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# User Conf
sudo useradd jenkins
echo "jenkins:cloud" | sudo chpasswd
echo "jenkins ALL = (ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins
sudo chmod 0440 /etc/sudoers.d/jenkins


sudo groupadd docker
sudo usermod -aG docker jenkins
sudo systemctl restart docker
