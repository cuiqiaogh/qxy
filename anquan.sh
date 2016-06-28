#!/bin/bash
read -p "please input the username:" USERNAME
read -s -p "please input password :" PASSWD
echo ""
useradd -g root $USERNAME
echo $PASSWD|passwd --stdin $USERNAME
sed -i "s@^#PermitRootLogin.*@&\nPermitRootLogin no@" /etc/ssh/sshd_config
echo -e "$Users $USERNAME has been created, root can not login from SSH "

while :; do echo
    read -p "Do you want change the ssh_port ? [y/n]: " PORT_yn
    if [[ ! $PORT_yn =~ ^[y,n]$ ]];then
        echo "${CWARNING}input error! Please only input 'y' or 'n'${CEND}"
    else
        if [ "$PORT_yn" == 'y' ];then
           read -p "Please input the ssh port (22-65535): " SSH_PORT
           sed -i "s@^#Port.*@&\nPort $SSH_PORT@" /etc/ssh/sshd_config
	   iptables -A INPUT -p tcp --dport $SSH_PORT -j ACCEPT
           service iptables save
  	   echo -e "ssh port changd $SSH_PORT  "
	   break
        else
           break
        fi
    fi	
done
service sshd restart
echo -e "The new SSH port is  $SSH_PORT "
