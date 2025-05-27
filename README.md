
# proxmox-vgpu

A simple script suite to enable **vGPU support on Proxmox VE**, including support for:

- **NVIDIA GRID vGPU**
- **Intel SR-IOV Graphics**

> Currently tested with Intel iGPUs supporting SR-IOV (12th Gen and newer).

---

## Requirements

### General Requirements

- **Proxmox VE**: Version 7.x or 8.x
- **Hardware Support**:
  - Virtualization (VT-x/VT-d) and SR-IOV must be enabled in BIOS.
  - A compatible **NVIDIA vGPU GPU** or an **Intel CPU** with iGPU that supports SR-IOV (e.g., 12th Gen and above).

---

## NVIDIA GRID vGPU Setup Guide

### Step 1: Clone Repository and Prepare Environment

```bash
git clone https://github.com/InboraStudio/Proxmox-VGPU.git
cd proxmox-vgpu/nvidia
./gpu01.sh     # Update Proxmox VE sources
./gpu02.sh     # Enable IOMMU
```

> Your system will automatically reboot after running `gpu02.sh`.

### Step 2: Verify IOMMU is Enabled

After reboot, check for IOMMU support:

```bash
dmesg | grep IOMMU
# Output should include: DMAR: IOMMU enabled
```

### Step 3: Install NVIDIA GRID vGPU Driver

```bash
./gpu03.sh     # Installs NVIDIA GRID vGPU driver (e.g., GRID 16.4)
```

> The system will reboot again.

### Step 4: Validate NVIDIA vGPU Installation

```bash
nvidia-smi
```

Sample output:

```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 535.161.05   Driver Version: 535.161.05   CUDA Version: N/A     |
|-------------------------------+----------------------+----------------------|
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
|-------------------------------+----------------------+----------------------|
|  0  Tesla P4            On    | 00000000:01:00.0 Off |                    0 |
|-------------------------------+----------------------+----------------------|
|  No running processes found                                          |
+-----------------------------------------------------------------------------+
```

---

##  Intel SR-IOV Graphics Setup Guide

### Step 1: Clone Repository and Enable IOMMU

```bash
git clone https://github.com/InboraStudio/Proxmox-VGPU.git
cd proxmox-vgpu/intel
./sriov01.sh   # Update sources and enable IOMMU
```

>  The system will reboot automatically.

### Step 2: Enable Intel SR-IOV

```bash
./sriov02.sh
```

> System will reboot again after running this script.

### Step 3: Verify vGPU Devices

Check whether SR-IOV virtual devices are available:

```bash
lspci | grep VGA
```

> You should see multiple entries if SR-IOV is correctly enabled.

---

##  Notes

- Intel SR-IOV only works on supported iGPUs (typically 12th Gen CPUs and newer).
- Always verify BIOS settings for VT-x/VT-d and SR-IOV.
- Ensure your hardware and Proxmox kernel are compatible with your GPU drivers.

---

##  License

This script is open-source and shared for educational and experimental use. Refer to the license file for more details.

---
