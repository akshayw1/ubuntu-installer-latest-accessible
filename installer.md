# Ubuntu 24.04 Custom ISO Creation - Step by Step Guide

## **Understanding Ubuntu 24.04 Architecture**

Ubuntu 24.04 uses:
- **Subiquity** as the backend (same as Ubuntu Server)
- **Flutter-based frontend** that communicates with Subiquity
- **Snap-based installer** architecture
- The installer is a **Snap package** that can be updated independently

## **Three Approaches for Custom ISO**

### **Approach 1: Replace the Default Flutter Installer (Recommended)**
Replace Ubuntu's Flutter installer with your custom one while keeping Subiquity backend.

### **Approach 2: Modify Existing Installer** 
Extract, modify, and rebuild Ubuntu's existing Flutter installer.

### **Approach 3: Snap Injection**
Inject your custom installer as a Snap package into the ISO.

---

## **Approach 1: Replace Default Flutter Installer**

### **Step 1: Environment Setup**
```bash
# Create working directory
mkdir -p ~/ubuntu-24-04-custom
cd ~/ubuntu-24-04-custom

# Download Ubuntu 24.04 ISO
wget https://releases.ubuntu.com/24.04/ubuntu-24.04.1-desktop-amd64.iso

# Install required tools
sudo apt update
sudo apt install cubic squashfs-tools
```

### **Step 2: Build Your Flutter Installer**
```bash
# Clone and build your Flutter installer
git clone https://github.com/akshayw1/ubuntu-installer-latest-accessible.git
cd ubuntu-installer-latest-accessible

# Install Flutter dependencies
flutter pub get
melos bootstrap

# Build for Linux
flutter build linux --release

# Create installer package
cd build/linux/x64/release/
tar -czf ~/ubuntu-24-04-custom/custom-installer.tar.gz bundle/
```

### **Step 3: Extract and Modify ISO with Cubic**
```bash
# Start Cubic
sudo cubic

# In Cubic GUI:
# 1. Create new project: ubuntu-24-04-custom
# 2. Select your downloaded ISO
# 3. Extract to chroot environment
```

### **Step 4: Remove Default Installer (In Chroot)**
```bash
# In Cubic chroot terminal:

# List current installer snap
snap list | grep installer

# Remove default installer snap
snap remove ubuntu-desktop-installer

# Remove installer packages
apt purge -y ubuntu-desktop-installer
apt autoremove -y

# Remove desktop entries
rm -f /usr/share/applications/ubuntu-desktop-installer.desktop
rm -f /etc/xdg/autostart/ubuntu-desktop-installer.desktop
```

### **Step 5: Install Your Custom Installer (In Chroot)**
```bash
# Create installation directory
mkdir -p /opt/custom-installer

# Copy your installer (adjust path as needed)
cp -r /host-home/$USER/ubuntu-24-04-custom/ubuntu-installer-latest-accessible/build/linux/x64/release/bundle/* /opt/custom-installer/

# Set permissions
chmod +x /opt/custom-installer/ubuntu_installer_latest_accessible
chown -R root:root /opt/custom-installer

# Install required dependencies for your Flutter app
apt install -y \
    libgtk-3-0 \
    libgtk-4-1 \
    libglu1-mesa \
    libegl1-mesa \
    libdrm2 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    libatspi2.0-0 \
    libsecret-1-0 \
    libnss3
```

### **Step 6: Create Autostart Entry (In Chroot)**
```bash
# Create autostart directory
mkdir -p /etc/xdg/autostart

# Create desktop entry for autostart
cat > /etc/xdg/autostart/custom-installer.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Custom Ubuntu Installer
Comment=Custom Ubuntu 24.04 Installation Wizard
Exec=/opt/custom-installer/ubuntu_installer_latest_accessible
Icon=/opt/custom-installer/data/flutter_assets/assets/icons/app_icon.png
Terminal=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=3
Categories=System;Settings;
StartupNotify=true
EOF

# Create manual launch shortcut
mkdir -p /home/ubuntu/Desktop
cat > /home/ubuntu/Desktop/Install-Ubuntu.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Install Ubuntu 24.04
Comment=Install Ubuntu 24.04 LTS to your computer
Exec=/opt/custom-installer/ubuntu_installer_latest_accessible
Icon=/opt/custom-installer/data/flutter_assets/assets/icons/app_icon.png
Terminal=false
Categories=System;Settings;
StartupNotify=true
EOF

chmod +x /home/ubuntu/Desktop/Install-Ubuntu.desktop
```

### **Step 7: Install Subiquity Backend (In Chroot)**
```bash
# Install Subiquity if not present
apt install -y subiquity

# Ensure it's configured properly
systemctl enable subiquity
```

### **Step 8: Configure System (In Chroot)**
```bash
# Update package lists
apt update

# Clean up
apt autoremove -y
apt autoclean

# Exit chroot
exit
```

### **Step 9: Generate ISO in Cubic**
1. Go to "Generate" tab in Cubic
2. Set Volume ID: `Ubuntu Custom 24.04`
3. Generate the ISO

---

## **Approach 2: Snap Injection Method**

### **Step 1: Create Your Installer as Snap**
```bash
# Create snapcraft.yaml for your installer
mkdir -p ~/installer-snap/snap
cd ~/installer-snap

cat > snap/snapcraft.yaml << 'EOF'
name: ubuntu-custom-installer
version: '1.0'
summary: Custom Ubuntu Installer
description: Custom Flutter-based Ubuntu installer
base: core22
grade: stable
confinement: classic

parts:
  installer:
    plugin: flutter
    source: https://github.com/akshayw1/ubuntu-installer-latest-accessible.git
    flutter-target: lib/main.dart

apps:
  ubuntu-custom-installer:
    command: ubuntu_installer_latest_accessible
    plugs:
      - desktop
      - wayland
      - x11
      - network
      - hardware-observe
      - system-observe
      - mount-observe
      - removable-media
EOF

# Build the snap
snapcraft
```

### **Step 2: Inject Snap into ISO**
```bash
# Use subiquity's injection script
git clone https://github.com/canonical/subiquity.git
cd subiquity

# Inject your snap into ISO
sudo ./scripts/inject-subiquity-snap.sh \
    ~/ubuntu-24.04.1-desktop-amd64.iso \
    ~/installer-snap/ubuntu-custom-installer_1.0_amd64.snap \
    ~/custom-ubuntu-24.04.iso
```

---

## **Approach 3: Modify Existing Installer**

### **Step 1: Extract Default Installer**
```bash
# Mount the ISO
mkdir -p /mnt/iso
sudo mount -o loop ubuntu-24.04.1-desktop-amd64.iso /mnt/iso

# Extract squashfs
sudo unsquashfs /mnt/iso/casper/filesystem.squashfs

# Look for installer snap
find squashfs-root/ -name "*installer*" -type f
```

### **Step 2: Get Installer Source**
```bash
# The canonical repository is archived, but we can get the code
# Check if there are any forks or mirrors available
# Or extract from the snap itself within the ISO
```

---

## **Testing Your Custom ISO**

### **Virtual Machine Testing**
```bash
# Test with QEMU/KVM
qemu-system-x86_64 \
    -cdrom ~/custom-ubuntu-24.04.iso \
    -m 6144 \
    -smp 4 \
    -enable-kvm \
    -netdev user,id=net0 \
    -device virtio-net,netdev=net0 \
    -vga virtio \
    -display gtk,gl=on \
    -machine type=q35
```

### **USB Creation**
```bash
# Create bootable USB
sudo dd if=~/custom-ubuntu-24.04.iso \
    of=/dev/sdX \
    bs=4M \
    status=progress \
    oflag=sync
```

---

## **Key Points for Ubuntu 24.04**

### **Architecture Understanding**
- Ubuntu 24.04 uses **Subiquity backend** (Python-based)
- **Flutter frontend** communicates with Subiquity via REST API
- Installer is a **Snap package** for easy updates
- Uses **systemd** for service management

### **Integration Requirements**
Your Flutter installer needs to:
1. **Communicate with Subiquity** backend via HTTP API
2. **Handle all installation steps** that Subiquity expects
3. **Work with Snap architecture**
4. **Support autoinstall.yaml** for automated installations

### **Subiquity API Integration**
```bash
# Key Subiquity endpoints your Flutter app needs to use:
# GET  /meta/status
# POST /locale
# POST /keyboard
# POST /source
# POST /network
# POST /proxy
# POST /apt
# POST /storage
# POST /identity
# POST /ssh
# POST /snaplist
# POST /drivers
# POST /codecs
# POST /install
```

---

## **Common Issues and Solutions**

### **Issue 1: Flutter App Doesn't Launch**
```bash
# Check dependencies in live environment
ldd /opt/custom-installer/ubuntu_installer_latest_accessible

# Install missing libraries
sudo apt install [missing-library]
```

### **Issue 2: Subiquity Backend Not Available**
```bash
# Check if Subiquity is running
systemctl status subiquity

# Start manually if needed
sudo systemctl start subiquity

# Check API endpoint
curl http://localhost/meta/status
```

### **Issue 3: Snap Conflicts**
```bash
# Remove conflicting snaps
snap remove ubuntu-desktop-installer

# Install your custom snap
snap install --dangerous your-installer.snap
```

---

## **Recommended Approach**

**Start with Approach 1** (Replace Default Installer) because:
1. It's the most straightforward
2. Keeps the proven Subiquity backend
3. Allows complete UI customization
4. Easier to debug and test

**Use Approach 2** (Snap Injection) if:
1. You want to preserve the original ISO structure
2. You need easier updates/distribution
3. You want to leverage Snap's confinement

The key is ensuring your Flutter app properly communicates with the Subiquity backend via its REST API endpoints.
