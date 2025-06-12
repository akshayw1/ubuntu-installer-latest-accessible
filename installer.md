# Custom Ubuntu ISO with Flutter-Based Installer Setup Guide

This comprehensive guide walks you through creating a bootable Ubuntu Desktop ISO with a custom Flutter-based installer using Cubic (Custom Ubuntu ISO Creator).

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
- **Host OS**: Ubuntu 20.04 or newer (recommended: Ubuntu 22.04 LTS)
- **RAM**: Minimum 4GB (8GB recommended for smooth operation)
- **Storage**: At least 20GB free space for ISO creation and testing
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

# Download Flutter SDK (latest stable)
cd ~/
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
tar xf flutter_linux_3.16.0-stable.tar.xz

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

# Install additional dependencies for Flutter Linux
sudo apt install clang libc++-dev libc++abi-dev
```

### Required Files
- Official Ubuntu Desktop ISO (e.g., `ubuntu-22.04.3-desktop-amd64.iso`)
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

### 2. Download Ubuntu Base ISO
```bash
cd ~/ubuntu-iso-builder/source

# Download Ubuntu 22.04 LTS Desktop ISO
wget https://releases.ubuntu.com/22.04/ubuntu-22.04.3-desktop-amd64.iso

# Verify download integrity (optional but recommended)
wget https://releases.ubuntu.com/22.04/SHA256SUMS
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

### 2. Configure Build Environment
```bash
# Enable Linux desktop support (if not already enabled)
flutter config --enable-linux-desktop

# Clean any previous builds
flutter clean

# Get latest dependencies
flutter pub get
```

### 3. Build for Production
```bash
# Build the Flutter app for Linux release
flutter build linux --release

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
   - **Project Name**: `ubuntu-custom-installer-22.04`
   - **Project Directory**: `/home/$USER/ubuntu-iso-builder/cubic-project`
   - **Original ISO**: Select your downloaded Ubuntu ISO
   - **Custom ISO**: Choose output location and name (e.g., `ubuntu-custom-akshay-22.04.iso`)
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

#### Install Required Dependencies
```bash
# Install essential packages for Flutter app
apt install -y \
    libgtk-3-0 \
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

# Install networking tools (if needed)
apt install -y network-manager
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

#### Create Desktop Entry
```bash
# Create autostart directory if it doesn't exist
mkdir -p /etc/xdg/autostart

# Create desktop entry for autostart
cat > /etc/xdg/autostart/ubuntu-installer.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Ubuntu Custom Installer
Comment=Custom Ubuntu Installation Wizard
Exec=/opt/ubuntu-installer/ubuntu_installer_latest_accessible
Icon=/opt/ubuntu-installer/data/flutter_assets/assets/icons/app_icon.png
Terminal=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=5
X-KDE-autostart-after=panel
Categories=System;Settings;
StartupNotify=true
EOF
```

#### Create Manual Launch Shortcut
```bash
# Create desktop shortcut for manual launch
mkdir -p /home/ubuntu/Desktop

cat > /home/ubuntu/Desktop/Install-Ubuntu.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Install Ubuntu
Comment=Install Ubuntu to your computer
Exec=/opt/ubuntu-installer/ubuntu_installer_latest_accessible
Icon=/opt/ubuntu-installer/data/flutter_assets/assets/icons/app_icon.png
Terminal=false
Categories=System;Settings;
StartupNotify=true
EOF

# Make it executable
chmod +x /home/ubuntu/Desktop/Install-Ubuntu.desktop
```

### 5. Remove Default Installer (Optional)
```bash
# Remove the default Ubuntu installer
apt purge -y ubiquity ubiquity-frontend-gtk ubiquity-frontend-kde subiquity

# Remove installer desktop shortcuts
rm -f /usr/share/applications/ubiquity.desktop
rm -f /usr/share/applications/ubuntu-desktop-installer.desktop

# Clean up residual files
rm -rf /usr/share/ubiquity
rm -rf /usr/share/ubuntu-desktop-installer
apt autoremove -y
```

### 6. System Customizations

#### Configure Display Manager
```bash
# Set up GDM for better compatibility
systemctl enable gdm
systemctl set-default graphical.target
```

#### Network Configuration
```bash
# Ensure NetworkManager is enabled
systemctl enable NetworkManager
systemctl enable systemd-resolved
```

#### User Configuration
```bash
# Set up the live user properly
usermod -aG sudo ubuntu
```

### 7. Cleanup and Optimization
```bash
# Clean package cache
apt clean
apt autoclean

# Remove temporary files
rm -rf /tmp/*
rm -rf /var/tmp/*

# Clear logs
find /var/log -type f -name "*.log" -delete
```

### 8. Exit Chroot Environment
```bash
# Exit the chroot environment
exit
```

### 9. Customize Boot Configuration
In Cubic's "Boot" tab:
- **Boot Menu Timeout**: Set to 5 seconds
- **Default Boot Option**: "Try or Install Ubuntu"
- **Custom Boot Parameters**: Add any needed kernel parameters

### 10. Generate ISO
1. Navigate to "Generate" tab
2. **Volume ID**: `Ubuntu Custom 22.04`
3. **ISO Filename**: Confirm the output path
4. Click "Generate" and wait for completion

---

## Testing and Deployment

### 1. Virtual Machine Testing

#### Using QEMU/KVM
```bash
# Install QEMU if not already installed
sudo apt install qemu-kvm qemu-utils virt-manager

# Test the ISO with adequate resources
qemu-system-x86_64 \
    -cdrom ~/ubuntu-iso-builder/output/ubuntu-custom-akshay-22.04.iso \
    -m 4096 \
    -smp 2 \
    -enable-kvm \
    -netdev user,id=net0 \
    -device virtio-net,netdev=net0 \
    -vga virtio \
    -display gtk,gl=on
```

#### Using VirtualBox
```bash
# Create new VM with:
# - Type: Linux, Ubuntu (64-bit)
# - RAM: 4GB minimum
# - Storage: 20GB virtual disk
# - Boot from ISO
```

### 2. Physical Hardware Testing

#### Create Bootable USB
```bash
# Identify USB device
lsblk

# Create bootable USB (replace /dev/sdX with your USB device)
sudo dd if=~/ubuntu-iso-builder/output/ubuntu-custom-akshay-22.04.iso \
    of=/dev/sdX \
    bs=4M \
    status=progress \
    oflag=sync

# Alternative: Use a GUI tool like Balena Etcher
```

#### Test Boot Process
1. Insert USB into target machine
2. Boot from USB (F12/F2/DEL during startup)
3. Verify:
   - System boots to live environment
   - Custom installer launches automatically
   - All functionality works as expected
   - Installation process completes successfully

### 3. Validation Checklist
- [ ] ISO boots successfully
- [ ] Live environment loads properly
- [ ] Custom installer launches automatically
- [ ] Installer UI is responsive and accessible
- [ ] Network connectivity works
- [ ] Installation to disk completes successfully
- [ ] Installed system boots properly
- [ ] All required packages are included

---

## Troubleshooting

### Common Issues and Solutions

#### Flutter App Doesn't Start
```bash
# Check dependencies in chroot
ldd /opt/ubuntu-installer/ubuntu_installer_latest_accessible

# Install missing libraries
apt install -y [missing-library-name]
```

#### Missing Graphics Drivers
```bash
# Add graphics drivers in chroot
apt install -y \
    mesa-utils \
    mesa-va-drivers \
    mesa-vdpau-drivers \
    libgl1-mesa-dri
```

#### Network Issues
```bash
# Ensure network services are enabled
systemctl enable NetworkManager
systemctl enable systemd-networkd
systemctl enable systemd-resolved
```

#### Autostart Issues
```bash
# Check desktop entry syntax
desktop-file-validate /etc/xdg/autostart/ubuntu-installer.desktop

# Verify permissions
ls -la /etc/xdg/autostart/ubuntu-installer.desktop
```

### Debug Mode
Enable debug logging in your Flutter app:
```dart
// Add to main.dart
import 'dart:developer' as developer;

void main() {
  developer.log('Installer starting...');
  runApp(MyApp());
}
```

---

## Advanced Customizations

### 1. Custom Branding
```bash
# In chroot environment
# Replace Plymouth theme
cp /host-home/$USER/custom-theme/* /usr/share/plymouth/themes/custom/

# Update GRUB theme
cp /host-home/$USER/grub-theme/* /boot/grub/themes/custom/

# Modify desktop background
cp /host-home/$USER/wallpaper.jpg /usr/share/backgrounds/custom-wallpaper.jpg
```

### 2. Preinstalled Software
```bash
# Install additional software in chroot
apt install -y \
    firefox \
    libreoffice \
    gimp \
    vlc \
    code
```

### 3. Accessibility Features
```bash
# Enable accessibility tools
apt install -y \
    orca \
    onboard \
    caribou \
    espeak-ng \
    brltty
```

### 4. Language Support
```bash
# Install language packs
apt install -y \
    language-pack-es \
    language-pack-fr \
    language-pack-de \
    language-pack-hi
```

### 5. Hardware Support
```bash
# Add firmware for better hardware support
apt install -y \
    linux-firmware \
    firmware-linux-nonfree \
    intel-microcode \
    amd64-microcode
```

---

## Maintenance and Updates

### Updating the Installer
1. Make changes to your Flutter project
2. Rebuild: `flutter build linux --release`
3. Create new ISO with updated installer
4. Test thoroughly before distribution

### Version Control
```bash
# Tag your releases
git tag -a v1.0.0 -m "Initial release of custom Ubuntu installer"
git push origin v1.0.0

# Track ISO versions
echo "v1.0.0" > /opt/ubuntu-installer/VERSION
```

### Documentation
- Keep detailed changelog of modifications
- Document any custom configurations
- Maintain testing procedures
- Record known issues and workarounds

---

## Security Considerations

1. **Verify Source Integrity**: Always verify Ubuntu ISO checksums
2. **Code Signing**: Consider signing your custom installer
3. **Minimal Attack Surface**: Remove unnecessary packages
4. **Regular Updates**: Keep base system updated
5. **Secure Defaults**: Configure secure default settings

---

## Distribution

### Sharing Your Custom ISO
1. **Checksums**: Provide SHA256 checksums
2. **GPG Signatures**: Sign your releases
3. **Documentation**: Include installation guide
4. **Support**: Provide clear support channels

### Legal Considerations
- Respect Ubuntu's trademark guidelines
- Include proper attribution
- Comply with package licenses
- Document any modifications

---

## Resources

- [Ubuntu Desktop Installer Documentation](https://ubuntu.com/desktop/developers)
- [Flutter Linux Desktop Documentation](https://docs.flutter.dev/platform-integration/linux/building)
- [Cubic Documentation](https://github.com/PJ-Singh-001/Cubic)
- [Ubuntu ISO Customization Guide](https://help.ubuntu.com/community/LiveCDCustomization)

---

## Support

For issues related to:
- **Flutter Installer**: [GitHub Issues](https://github.com/akshayw1/ubuntu-installer-latest-accessible/issues)
- **Cubic**: [Cubic Support](https://github.com/PJ-Singh-001/Cubic/issues)
- **Ubuntu**: [Ubuntu Community](https://askubuntu.com/)

---

*Last updated: June 2025*
