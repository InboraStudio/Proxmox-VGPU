#!/bin/sh
# Author: DoraCloud Technology Ltd.co
#         
# Date: 2022/05/07
#
# Enable IO-MMU on PVE Server


# 复制如下脚本，启用IO-MMU
echo ""
echo "********************************************"
echo "***  Enable IO-MMU on proxmox host       ***"
echo "********************************************"
# /etc/default/grub 的GRUB_CMDLINE_LINUX_DEFAULT，增加 intel_iommu=on iommu=pt
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt"/g' /etc/default/grub

echo ""
echo "    Update grub .... "
update-grub

# 加载 vfio vfio_iommu_type1 vfio_pci vfio_virqfd 4个Modules
echo vfio >> /etc/modules
echo vfio_iommu_type1 >> /etc/modules
echo vfio_pci >> /etc/modules
echo vfio_virqfd >> /etc/modules


echo "options vfio_iommu_type1 allow_unsafe_interrupts=1" > /etc/modprobe.d/iommu_unsafe_interrupts.conf
echo "options kvm ignore_msrs=1 report_ignored_msrs=0" > /etc/modprobe.d/kvm.conf
echo "blacklist nouveau" >>/etc/modprobe.d/disable-nouveau.conf
echo "options nouveau modeset=0" >>/etc/modprobe.d/disable-nouveau.conf

update-initramfs -u
echo ""
echo "    Proxmox host reboot ............."
reboot

