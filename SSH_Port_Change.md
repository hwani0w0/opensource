# Linux 에서 SSH Port 변경

## Port Check
```
semanage port -l | grep ssh
```

## port config
```
## Port Add
semanage port -a -t ssh_port_t -p tcp 8089

# Port Del
semanage port -d -t 8090 -p tcp 8090
```

## sshd restart
```
systemctl restart sshd
```
