# Shell script to run on VM for setting up environment

#Set Hostname
hn="rkcdhmaster1"
fhn="rkcdhmaster1.hadoop.com"

#Disable Linux Transparent Huge Pages (THP)
echo "echo never  > /sys/kernel/mm/redhat_transparent_hugepage/enabled" >> /etc/rc.local
echo "echo never  > /sys/kernel/mm/redhat_transparent_hugepage/defrag" >> /etc/rc.local
echo "vm.swappiness=10" >> /etc/sysctl.conf

#Disable SELINUX
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

#Stop Firewall
service iptables stop
chkconfig iptables off

#Enable NTP
yum -y install ntp
chkconfig ntpd on
/etc/init.d/ntpd start

#Replace hostname 
#sed -i 's/localhost.localdomain/${hn}/' /etc/sysconfig/network
sed -i "s/base.hadoop.com/${hn}/" /etc/sysconfig/network

sed -i "s/localhost.localdomain/rkcdhworker3.hadoop.com/" /etc/sysconfig/network

#hostname in /etc/hosts
ip="$(ifconfig | grep -A 1 'eth1' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"
echo "${ip}  ${fhn}  ${hn}" >> /etc/hosts
