# Custom Ubuntu 24.04 ISO with Flutter-Based Installer Setup Guide

This comprehensive guide walks you through creating a bootable Ubuntu 24.04 LTS Desktop ISO with a custom Flutter-based installer using Cubic (Custom Ubuntu ISO Creator).

## Table of Contents
- [Prerequisites](#prerequisites)
- [Environment Setup](#environment-setup)
- [Building the Flutter Installer](#building-the-flutter-installer)
- [Creating Custom ISO with Cubic](#creating-custom-iso-with-cubic)
- [Testing and Deployment](#testing-and-deployment)
- [Troubleshooting](#troubleshooting)
- [Advanced Customizations](#advanced-customizations)

---

## Prerequisites

### System Requirements
- **Host OS**: Ubuntu 22.04 or newer (recommended: Ubuntu 24.04 LTS)
- **RAM**: Minimum 6GB (8GB recommended for smooth operation)
- **Storage**: At least 25GB free space for ISO creation and testing
- **Architecture**: x86_64 (amd64)

### Required Software

#### 1. Install Cubic
```bash
# Add Cubic PPA repository
sudo apt-add-repository ppa:cubic-wizard/release
sudo apt update

# Install Cubic
sudo apt install cubic

# Verify installation
cubic --version
```

#### 2. Install Flutter and Dependencies
```bash
# Install Flutter dependencies
sudo apt install curl git unzip xz-utils zip libglu1-mesa

# Download Flutter SDK (latest stable - 3.24.x series)
cd ~/
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz
tar xf flutter_linux_3.24.0-stable.tar.xz

# Add Flutter to PATH
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify Flutter installation
flutter doctor
```

#### 3. Install Melos (Monorepo Management)
```bash
# Activate Melos globally
dart pub global activate melos

# Add Dart global packages to PATH
echo 'export PATH="$HOME/.pub-cache/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify Melos installation
melos --version
```

#### 4. Additional Build Tools
```bash
# Install build essentials
sudo apt install build-essential cmake ninja-build pkg-config libgtk-3-dev

# Install additional dependencies for Flutter Linux (Ubuntu 24.04 specific)
sudo apt install clang libc++-dev libc++abi-dev libgtk-4-dev
```

### Required Files
- Official Ubuntu 24.04 LTS Desktop ISO (e.g., `ubuntu-24.04.1-desktop-amd64.iso`)
- Your Flutter installer project: `ubuntu-installer-latest-accessible`

---

## Environment Setup

### 1. Create Working Directory
```bash
# Create project workspace
mkdir -p ~/ubuntu-iso-builder
cd ~/ubuntu-iso-builder

# Create subdirectories
mkdir -p {source,build,output,testing}
```

### 2. Download Ubuntu 24.04 Base ISO
```bash
cd ~/ubuntu-iso-builder/source

# Download Ubuntu 24.04 LTS Desktop ISO
wget https://releases.ubuntu.com/24.04/ubuntu-24.04.1-desktop-amd64.iso

# Verify download integrity (optional but recommended)
wget https://releases.ubuntu.com/24.04/SHA256SUMS
sha256sum -c SHA256SUMS --ignore-missing
```

### 3. Clone Flutter Installer Project
```bash
cd ~/ubuntu-iso-builder/source

# Clone your custom installer repository
git clone https://github.com/akshayw1/ubuntu-installer-latest-accessible.git
cd ubuntu-installer-latest-accessible

# Verify project structure
ls -la
```

---

## Building the Flutter Installer

### 1. Project Setup and Dependencies
```bash
cd ~/ubuntu-iso-builder/source/ubuntu-installer-latest-accessible

# Bootstrap the project with Melos
melos bootstrap

# Check for any dependency issues
flutter doctor -v

# Analyze project for potential issues
flutter analyze
```

### 2. Configure Build Environment for Ubuntu 24.04
```bash
# Enable Linux desktop support (if not already enabled)
flutter config --enable-linux-desktop

# Clean any previous builds
flutter clean

# Update pubspec.yaml for Ubuntu 24.04 compatibility
# Ensure GTK 4 support if needed
flutter pub get

# Update Flutter to latest stable if needed
flutter upgrade
```

### 3. Build for Production
```bash
# Build the Flutter app for Linux release with Ubuntu 24.04 optimizations
flutter build linux --release --target-platform linux-x64

# Verify build output
ls -la build/linux/x64/release/bundle/

# Test the built application locally
./build/linux/x64/release/bundle/ubuntu_installer_latest_accessible
```

### 4. Prepare Installation Bundle
```bash
# Create a complete installation package
cd build/linux/x64/release/
tar -czf ~/ubuntu-iso-builder/build/ubuntu-installer-bundle.tar.gz bundle/

# Verify bundle contents
tar -tzf ~/ubuntu-iso-builder/build/ubuntu-installer-bundle.tar.gz | head -20
```

---

## Creating Custom ISO with Cubic

### 1. Launch Cubic
```bash
# Start Cubic with elevated privileges
sudo cubic
```

### 2. Create New Cubic Project
1. **Welcome Screen**: Click "Next"
2. **Project Page**:
   - **Project Name**: `ubuntu-custom-installer-24.04`
   - **Project Directory**: `/home/$USER/ubuntu-iso-builder/cubic-project`
   - **Original ISO**: Select your downloaded Ubuntu 24.04 ISO
   - **Custom ISO**: Choose output location and name (e.g., `ubuntu-custom-akshay-24.04.iso`)
3. **Extract**: Click "Next" and wait for extraction to complete

### 3. Configure Live Environment (Chroot)
Once in the chroot terminal environment:

#### Update Package Lists
```bash
# Update package repository
apt update

# Upgrade existing packages (optional)
apt upgrade -y
```

#### Install Required Dependencies for Ubuntu 24.04
```bash
# Install essential packages for Flutter app (Ubuntu 24.04 specific)
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
    libnss3 \
    libgdk-pixbuf-2.0-0 \
    libcairo-gobject2 \
    libpango-1.0-0 \
    libharfbuzz0b

# Install networking tools (Ubuntu 24.04 uses newer NetworkManager)
apt install -y network-manager netplan.io
```

### 4. Install Custom Flutter Installer

#### Copy Installer Files
```bash
# Create installation directory
mkdir -p /opt/ubuntu-installer

# Copy the Flutter installer bundle
# Note: /host-home maps to your actual home directory in Cubic
cp -r /host-home/$USER/ubuntu-iso-builder/source/ubuntu-installer-latest-accessible/build/linux/x64/release/bundle/* /opt/ubuntu-installer/

# Set proper permissions
chmod +x /opt/ubuntu-installer/ubuntu_installer_latest_accessible
chown -R root:root /opt/ubuntu-installer
```

#### Create Desktop Entry for Ubuntu 24.04
```bash
# Create autostart directory if it doesn't exist
mkdir -p /etc/xdg/autostart

# Create desktop entry for autostart (Ubuntu 24.04 compatible)
cat > /etc/xdg/autostart/ubuntu-installer.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Ubuntu Custom Installer
Comment=Custom Ubuntu 24.04 Installation Wizard
Exec=/opt/ubuntu-installer/ubuntu_installer_latest_accessible
Icon=/opt/ubuntu-installer/data/flutter_assets/assets/icons/app_icon.png
Terminal=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=5
X-KDE-autostart-after=panel
Categories=System;Settings;
StartupNotify=true
X-Ubuntu-Gettext-Domain=ubuntu-installer
EOF
```

#### Create Manual Launch Shortcut
```bash
# Create desktop shortcut for manual launch
mkdir -p /home/ubuntu/Desktop

cat > /home/ubuntu/Desktop/Install-Ubuntu.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Install Ubuntu 24.04
Comment=Install Ubuntu 24.04 LTS to your computer
Exec=/opt/ubuntu-installer/ubuntu_installer_latest_accessible
Icon=/opt/ubuntu-installer/data/flutter_assets/assets/icons/app_icon.png
Terminal=false
Categories=System;Settings;
StartupNotify=true
X-Ubuntu-Gettext-Domain=ubuntu-installer
EOF

# Make it executable
chmod +x /home/ubuntu/Desktop/Install-Ubuntu.desktop
```

### 5. Remove Default Installer (Updated for Ubuntu 24.04)
```bash
# Remove the default Ubuntu 24.04 installer (uses different package names)
apt purge -y ubuntu-desktop-installer ubiquity ubiquity-frontend-gtk

# Remove installer desktop shortcuts
rm -f /usr/share/applications/ubuntu-desktop-installer.desktop
rm -f /usr/share/applications/ubiquity.desktop

# Clean up residual files
rm -rf /usr/share/ubuntu-desktop-installer
rm -rf /usr/share/ubiquity
apt autoremove -y
```

### 6. System Customizations for Ubuntu 24.04

#### Configure Display Manager (GDM4)
```bash
# Set up GDM for Ubuntu 24.04 (uses GDM3 with Wayland by default)
systemctl enable gdm
systemctl set-default graphical.target

# Configure for X11 if needed for Flutter compatibility
echo "WaylandEnable=false" >> /etc/gdm3/custom.conf
```

#### Network Configuration (Ubuntu 24.04)
```bash
# Ensure NetworkManager is enabled (Ubuntu 24.04 default)
systemctl enable NetworkManager
systemctl enable systemd-resolved

# Configure Netplan (Ubuntu 24.04 default)
systemctl enable systemd-networkd
```

#### User Configuration
```bash
# Set up the live user properly
usermod -aG sudo ubuntu

# Ensure proper permissions for Ubuntu 24.04
usermod -aG adm,dialout,cdrom,floppy,audio,dip,video,plugdev,netdev,lpadmin ubuntu
```

### 7. Ubuntu 24.04 Specific Optimizations
```bash
# Install Ubuntu 24.04 specific packages
apt install -y \
    snapd \
    ubuntu-advantage-tools \
    update-notifier \
    ubuntu-drivers-common

# Configure AppArmor for better security
systemctl enable apparmor
systemctl enable snapd.apparmor

# Install newer Mesa drivers for better graphics support
apt install -y \
    mesa-utils \
    mesa-va-drivers \
    mesa-vdpau-drivers \
    libgl1-mesa-dri \
    mesa-vulkan-drivers
```

### 8. Cleanup and Optimization
```bash
# Clean package cache
apt clean
apt autoclean

# Remove temporary files
rm -rf /tmp/*
rm -rf /var/tmp/*

# Clear logs
find /var/log -type f -name "*.log" -delete

# Update package database
apt update
```

### 9. Exit Chroot Environment
```bash
# Exit the chroot environment
exit
```

### 10. Customize Boot Configuration for Ubuntu 24.04
In Cubic's "Boot" tab:
- **Boot Menu Timeout**: Set to 5 seconds
- **Default Boot Option**: "Try or Install Ubuntu"
- **Custom Boot Parameters**: Add `splash quiet` for Ubuntu 24.04
- **UEFI Support**: Ensure enabled for modern systems

### 11. Generate ISO
1. Navigate to "Generate" tab
2. **Volume ID**: `Ubuntu Custom 24.04`
3. **ISO Filename**: Confirm the output path
4. **Legacy BIOS Support**: Enable if needed
5. **UEFI Support**: Enable (default for Ubuntu 24.04)
6. Click "Generate" and wait for completion

---

## Testing and Deployment

### 1. Virtual Machine Testing

#### Using QEMU/KVM (Ubuntu 24.04 optimized)
```bash
# Install QEMU if not already installed
sudo apt install qemu-kvm qemu-utils virt-manager

# Test the ISO with adequate resources for Ubuntu 24.04
qemu-system-x86_64 \
    -cdrom ~/ubuntu-iso-builder/output/ubuntu-custom-akshay-24.04.iso \
    -m 6144 \
    -smp 4 \
    -enable-kvm \
    -netdev user,id=net0 \
    -device virtio-net,netdev=net0 \
    -vga virtio \
    -display gtk,gl=on \
    -machine type=q35 \
    -cpu host
```

#### Using VirtualBox
```bash
# Create new VM with Ubuntu 24.04 requirements:
# - Type: Linux, Ubuntu (64-bit)
# - RAM: 6GB minimum (8GB recommended)
# - Storage: 25GB virtual disk
# - Enable 3D acceleration
# - Boot from ISO
```

### 2. Physical Hardware Testing

#### Create Bootable USB with Ubuntu 24.04 Support
```bash
# Identify USB device
lsblk

# Create bootable USB (replace /dev/sdX with your USB device)
sudo dd if=~/ubuntu-iso-builder/output/ubuntu-custom-akshay-24.04.iso \
    of=/dev/sdX \
    bs=4M \
    status=progress \
    oflag=sync

# Alternative: Use Startup Disk Creator (Ubuntu 24.04 default)
usb-creator-gtk
```

#### Test Boot Process
1. Insert USB into target machine
2. Boot from USB (F12/F2/DEL during startup)
3. Verify:
   - System boots to live environment
   - Custom installer launches automatically
   - All functionality works with Ubuntu 24.04
   - Installation process completes successfully
   - Secure Boot compatibility (if enabled)

### 3. Validation Checklist for Ubuntu 24.04
- [ ] ISO boots successfully on UEFI and Legacy BIOS
- [ ] Live environment loads with Wayland/X11
- [ ] Custom installer launches automatically
- [ ] Installer UI is responsive and accessible
- [ ] Network connectivity works with NetworkManager
- [ ] Installation to disk completes successfully
- [ ] Installed system boots properly
- [ ] All required packages are included
- [ ] Secure Boot compatibility verified

---

## Troubleshooting

### Common Issues and Solutions for Ubuntu 24.04

#### Flutter App Doesn't Start
```bash
# Check dependencies in chroot
ldd /opt/ubuntu-installer/ubuntu_installer_latest_accessible

# Install missing libraries for Ubuntu 24.04
apt install -y [missing-library-name]

# Check for Wayland compatibility issues
export GDK_BACKEND=x11
```

#### Graphics Issues on Ubuntu 24.04
```bash
# Add graphics drivers in chroot
apt install -y \
    mesa-utils \
    mesa-va-drivers \
    mesa-vdpau-drivers \
    libgl1-mesa-dri \
    mesa-vulkan-drivers \
    nvidia-driver-535 \
    intel-media-va-driver
```

#### Network Issues with NetworkManager
```bash
# Ensure network services are enabled
systemctl enable NetworkManager
systemctl enable systemd-networkd
systemctl enable systemd-resolved

# Configure Netplan for Ubuntu 24.04
cat > /etc/netplan/01-network-manager-all.yaml << 'EOF'
network:
  version: 2
  renderer: NetworkManager
EOF
```

#### Wayland Compatibility Issues
```bash
# Force X11 session if needed
echo "WaylandEnable=false" >> /etc/gdm3/custom.conf

# Or set environment variable
export GDK_BACKEND=x11
export XDG_SESSION_TYPE=x11
```

### Debug Mode for Ubuntu 24.04
Enable enhanced logging in your Flutter app:
```dart
// Add to main.dart
import 'dart:developer' as developer;
import 'dart:io';

void main() {
  developer.log('Ubuntu 24.04 Installer starting...');
  developer.log('Platform: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}');
  runApp(MyApp());
}
```

---

## Advanced Customizations for Ubuntu 24.04

### 1. Custom Branding
```bash
# In chroot environment
# Replace Plymouth theme for Ubuntu 24.04
cp /host-home/$USER/custom-theme/* /usr/share/plymouth/themes/custom/
update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/custom/custom.plymouth 100

# Update GRUB theme
cp /host-home/$USER/grub-theme/* /boot/grub/themes/custom/
echo 'GRUB_THEME="/boot/grub/themes/custom/theme.txt"' >> /etc/default/grub

# Modify desktop background for Ubuntu 24.04
cp /host-home/$USER/wallpaper.jpg /usr/share/backgrounds/custom-wallpaper.jpg
```

### 2. Preinstalled Software for Ubuntu 24.04
```bash
# Install additional software in chroot
apt install -y \
    firefox \
    thunderbird \
    libreoffice \
    gimp \
    vlc \
    code \
    steam-installer \
    discord

# Install Snap packages
snap install \
    code \
    discord \
    spotify \
    telegram-desktop
```

### 3. Enhanced Accessibility Features
```bash
# Enable accessibility tools for Ubuntu 24.04
apt install -y \
    orca \
    onboard \
    caribou \
    espeak-ng \
    brltty \
    gnome-accessibility-themes \
    at-spi2-core
```

### 4. Extended Language Support
```bash
# Install language packs for Ubuntu 24.04
apt install -y \
    language-pack-es \
    language-pack-fr \
    language-pack-de \
    language-pack-hi \
    language-pack-zh-hans \
    language-pack-ja \
    language-pack-ar

# Install fonts for better language support
apt install -y \
    fonts-noto \
    fonts-noto-cjk \
    fonts-noto-color-emoji
```

### 5. Modern Hardware Support
```bash
# Add firmware for Ubuntu 24.04 hardware support
apt install -y \
    linux-firmware \
    linux-firmware-nonfree \
    intel-microcode \
    amd64-microcode \
    nvidia-firmware-535-535.183.01 \
    firmware-sof-signed

# Install additional drivers
ubuntu-drivers autoinstall
```

### 6. Security Enhancements
```bash
# Configure AppArmor profiles
aa-enforce /etc/apparmor.d/*

# Install security tools
apt install -y \
    ufw \
    fail2ban \
    rkhunter \
    lynis \
    ubuntu-advantage-tools
```

---

## Maintenance and Updates

### Updating the Installer for Ubuntu 24.04
1. Update Flutter to latest stable version
2. Test compatibility with Ubuntu 24.04 packages
3. Rebuild: `flutter build linux --release --target-platform linux-x64`
4. Create new ISO with updated installer
5. Test on both virtual and physical hardware

### Version Control and Tracking
```bash
# Tag your releases for Ubuntu 24.04
git tag -a v2.0.0-ubuntu24.04 -m "Ubuntu 24.04 LTS release"
git push origin v2.0.0-ubuntu24.04

# Track ISO versions
echo "v2.0.0-ubuntu24.04" > /opt/ubuntu-installer/VERSION
```

---

## Security Considerations for Ubuntu 24.04

1. **Verify Source Integrity**: Always verify Ubuntu 24.04 ISO checksums
2. **Secure Boot Support**: Test with Secure Boot enabled
3. **AppArmor Profiles**: Configure proper AppArmor profiles
4. **Regular Updates**: Keep base system updated with Ubuntu Pro if available
5. **Minimal Attack Surface**: Remove unnecessary packages and services
6. **Encrypted Installation**: Support full disk encryption options

---

## Distribution and Deployment

### Sharing Your Custom Ubuntu 24.04 ISO
1. **Checksums**: Provide SHA256 and SHA512 checksums
2. **GPG Signatures**: Sign your releases with GPG
3. **Documentation**: Include comprehensive installation guide
4. **Support Channels**: Provide clear support and feedback channels
5. **Compatibility Matrix**: Document tested hardware configurations

### Legal and Compliance
- Follow Ubuntu 24.04 trademark guidelines
- Include proper attribution and licensing
- Comply with all package licenses
- Document modifications and customizations
- Respect canonical's branding requirements

---

## Resources for Ubuntu 24.04

- [Ubuntu 24.04 Release Notes](https://wiki.ubuntu.com/NobleNumbat/ReleaseNotes)
- [Ubuntu Desktop Installer Documentation](https://ubuntu.com/desktop/developers)
- [Flutter Linux Desktop Documentation](https://docs.flutter.dev/platform-integration/linux/building)
- [Cubic Documentation](https://github.com/PJ-Singh-001/Cubic)
- [Ubuntu 24.04 Customization Guide](https://help.ubuntu.com/community/LiveCDCustomization)
- [Netplan Configuration](https://netplan.io/)

---

## Support and Community

For issues related to:
- **Flutter Installer**: [GitHub Issues](https://github.com/akshayw1/ubuntu-installer-latest-accessible/issues)
- **Cubic**: [Cubic Support](https://github.com/PJ-Singh-001/Cubic/issues)
- **Ubuntu 24.04**: [Ubuntu Community](https://askubuntu.com/)
- **Ubuntu Pro**: [Ubuntu Pro Support](https://ubuntu.com/pro)

---

## Changelog

### Version 2.0.0 - Ubuntu 24.04 LTS
- Updated base system to Ubuntu 24.04 LTS
- Enhanced Flutter compatibility with GTK 4
- Improved Wayland support with X11 fallback
- Added Secure Boot compatibility
- Updated package dependencies for Ubuntu 24.04
- Enhanced graphics driver support
- Improved accessibility features
- Added modern hardware support
- Enhanced security configurations

---

*Last updated: June 2025 - Ubuntu 24.04 LTS Edition*
