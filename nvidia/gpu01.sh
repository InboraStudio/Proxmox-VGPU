#!/bin/sh
# Author: DoraCloud Technology Ltd.co
#         
# Date: 2022/05/07
#
# DoraCloud for Proxmox Enable vGPU
# Phase 1: update source to mirrors.ustc.edu.cn

cp /etc/apt/sources.list /etc/apt/sources.list.backup
sed -i 's|^deb http://ftp.debian.org|deb https://mirrors.ustc.edu.cn|g' /etc/apt/sources.list
sed -i 's|^deb http://security.debian.org|deb https://mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list

mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
CODENAME=`cat /etc/os-release |grep PRETTY_NAME |cut -f 2 -d "(" |cut -f 1 -d ")"`


# 修改ceph source
sed -i.bak 's|^deb https://enterprise.proxmox.com/debian/ceph-quincy bookworm enterprise|deb https://mirrors.ustc.edu.cn/proxmox/debian/ceph-quincy/ bookworm no-subscription|g' /etc/apt/sources.list.d/ceph.list

#echo "deb https://mirrors.nju.edu.cn/proxmox/debian/pve $CODENAME pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list
echo "deb https://mirrors.ustc.edu.cn/proxmox/debian $CODENAME pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list

wget https://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-$CODENAME.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-$CODENAME.gpg

#更新
apt update && apt install  pve-headers-$(uname -r)  dkms mdevctl -y

