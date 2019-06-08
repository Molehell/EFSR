#!/bin/sh
Banben=`rpm -q centos-release | awk -F "-" '{print $3}'`

yum -y update nss
yum -y install openssl  glibc
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

if  [ $Banben -eq 6 ];then
rpm -Uvh https://www.elrepo.org/elrepo-release-6-8.el6.elrepo.noarch.rpm
elif [ $Banben -eq 7 ];then
rpm -Uvh https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
fi

yum -y install gcc --enablerepo=elrepo
yum -y install libgcc* --enablerepo=elrepo
yum -y groupinstall "Development Tools" --enablerepo=elrepo
yum -y install ncurses-devel --enablerepo=elrepo
yum -y install hmaccalc zlib-devel binutils-devel elfutils-libelf-devel --enablerepo=elrepo
yum repolist
yum -y install dracut --enablerepo=elrepo
yum -y install dracut-kernel --enablerepo=elrepo
yum -y --enablerepo=elrepo-kernel install kernel-lt 
yum -y --enablerepo=elrepo-kernel update 
yum -y --enablerepo=elrepo upgrade 
yum -y install xe-guest-utilities-xenstore.x86_64 


if  [ $Banben -eq 6 ];then
Cen=`cat /etc/grub.conf | grep title | awk '/elrepo.x86/{print NR}'`
A=$[Cen-1]
sed -i "s/default=0/default=$A/" /etc/grub.conf
sed -i "s/default=0/default=$A/" /boot/grub/grub.conf
elif [ $Banben -eq 7 ];then
grub2-set-default "`cat /boot/grub2/grub.cfg | grep "elrepo.x86_64) 7 (Core)" | awk -F "'" '{print $2}'| head -n 1`"
fi
reboot
