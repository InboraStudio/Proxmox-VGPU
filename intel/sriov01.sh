#!/bin/bash
# Author: DoraCloud Technology Ltd.co
#         
# Date: 2022/05/07
#
# DoraCloud for Proxmox Enable vGPU
# Phase 1: update source to mirrors.ustc.edu.cn

CODENAME=`cat /etc/os-release |grep PRETTY_NAME |cut -f 2 -d "(" |cut -f 1 -d ")"`


cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i 's|^deb http://ftp.debian.org|deb https://mirrors.ustc.edu.cn|g' /etc/apt/sources.list
sed -i 's|^deb http://security.debian.org|deb https://mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list

# 修改ceph source
sed -i.bak 's|^deb https://enterprise.proxmox.com/debian/ceph-quincy bookworm enterprise|deb https://mirrors.ustc.edu.cn/proxmox/debian/ceph-quincy/ bookworm no-subscription|g' /etc/apt/sources.list.d/ceph.list

# deb https://enterprise.proxmox.com/debian/ceph-quincy bookworm enterprise
#deb https://mirrors.ustc.edu.cn/proxmox/debian/ceph-quincy/ bookworm no-subscription

sed -i.bak "s#http://download.proxmox.com/debian#https://mirrors.ustc.edu.cn/proxmox/debian#g" /usr/share/perl5/PVE/CLI/pveceph.pm     #中科大源


mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak

echo "deb https://mirrors.ustc.edu.cn/proxmox/debian $CODENAME pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list

wget https://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-$CODENAME.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-$CODENAME.gpg



#更新
apt update -y 

#如果是PVE7，安装 kernel 6.2

pve_version=$(pveversion|awk -F '/' '{print $2}'|cut -c1)
if [[ $pve_version == "7" ]]; then
    apt install  pve-kernel-6.2 -y
fi

if [[ $pve_version == "8" ]]; then
    apt install  proxmox-kernel-6.5.13-5-pve -y
fi

reboot

