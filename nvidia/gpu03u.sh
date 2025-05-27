#!/bin/sh
# Author: DoraCloud Technology Ltd.co
#         
# Date: 2022/05/07
#
# Unlock NVIDIA GTX 1060 

echo ""
echo "********************************************************"
echo "***  Unlock NVIDIA GTX1060                           ***"
echo "********************************************************"


echo ""
echo ""
echo "    Download vgpu_lock "
echo ""
apt install git-core -y

git clone https://gitlab.com/polloloco/vgpu-proxmox.git



echo ""
echo ""
echo "********************************************************"
echo "    Uninstall current NVIDIA Driver to 535.161.05 " 
echo ""
./NVIDIA-Linux-x86_64-535.161.05-vgpu-kvm.run --uninstall

echo ""
echo ""
echo "********************************************************"
echo "    Apply vgpu_unlock to 535.161.05 " 
echo ""

./NVIDIA-Linux-x86_64-535.161.05-vgpu-kvm.run --apply-patch $(pwd)/vgpu-proxmox/535.161.05.patch

./NVIDIA-Linux-x86_64-535.161.05-vgpu-kvm-custom.run --dkms -s



echo ""
echo ""
echo "********************************************************"
echo "    Install RUST "
echo ""
#设置rustup的source为 USTC
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
#wget -qO- https://cdn.jsdelivr.net/gh/rust-lang-nursery/rustup.rs/rustup-init.sh |sh  -s -- -y

echo ""
echo ""
echo "********************************************************"
echo "    Config cargo "
echo ""
#加载cargo的环境变量
source ~/.cargo/env

#设置cargo的源镜像为 USTC
cat >~/.cargo/config <<EOF
[source.crates-io]
replace-with = 'ustc'

[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"
EOF


echo ""
echo ""
echo "********************************************************"
echo "   Building vgpu_unlock-rs  "
echo ""

#下载 vgpu_unlock-rs 项目
cd /opt/
git clone https://gitee.com/deskpool/vgpu_unlock-rs
cd vgpu_unlock-rs/
cargo build --release

echo ""
echo ""
echo "********************************************************"
echo "   Create profile_override.toml , vgpu.service && vgpu-mgr.service " 
echo ""


mkdir /etc/vgpu_unlock
touch /etc/vgpu_unlock/profile_override.toml


mkdir /etc/systemd/system/{nvidia-vgpud.service.d,nvidia-vgpu-mgr.service.d}
echo -e "[Service]\nEnvironment=LD_PRELOAD=/opt/vgpu_unlock-rs/target/release/libvgpu_unlock_rs.so" > /etc/systemd/system/nvidia-vgpud.service.d/vgpu_unlock.conf
echo -e "[Service]\nEnvironment=LD_PRELOAD=/opt/vgpu_unlock-rs/target/release/libvgpu_unlock_rs.so" > /etc/systemd/system/nvidia-vgpu-mgr.service.d/vgpu_unlock.conf




echo ""
echo ""
echo "********************************************************"
echo "    Reboot Proxmox VE .....  "
echo "    run  mdevctl types     to check vGPU is installed.     "
echo ""

sync

reboot
