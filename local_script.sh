#!/bin/bash

#if zabbix agent installed or not
zabbix_agentd --version > /dev/null 2>&1
if [ $? == 0 ]
then echo "zabbix agent already installed" 
else 
#Add repo
yum install -y https://repo.zabbix.com/zabbix/5.0/rhel/$(rpm -E %{rhel})/x86_64/zabbix-release-5.0-1.el$(rpm -E %{rhel}).noarch.rpm
yum clean all
yum install zabbix-agent -y
fi

#configure agentd.conf
sed -i 's/^Server=.*/Server=127.0.0.1/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/^ServerActive=.*/ServerActive=127.0.0.1/g' /etc/zabbix/zabbix_agentd.conf
sed -i '/^Hostname=.*/s/^/#/' /etc/zabbix/zabbix_agentd.conf
sed -i 's/.*ListenPort=.*/ListenPort=10050/g' /etc/zabbix/zabbix_agentd.conf
sed -i '/.*HostMetadata=.*/s/^/#/' /etc/zabbix/zabbix_agentd.conf
sed -i '167i HostMetadata=linux' /etc/zabbix/zabbix_agentd.conf

systemctl enable --now zabbix-agent
systemctl restart zabbix-agent

#check firewall

#systemctl is-active firewalld
#if [ $? == 0 ]
#then firewall-cmd --add-service=zabbix-agent --permanent
#firewall-cmd --reload
#else echo "firewall state : inactive"
#fi
