#!/bin/bash

set -ouex pipefail

# libvirtery
dnf5 install -y qemu libvirt guestfs-tools
systemctl enable libvirtd.service

# automountery
systemctl disable ublue-os-media-automount.service
dnf5 remove -y ublue-os-media-automount-udev
rm /usr/lib/udev/rules.d/99-framework-steam-automount.rules
rm /usr/lib/udev/rules.d/99-steamos-automount.rules

# ntfsery
systemctl --global disable ntfs-nag.service
rm /usr/lib/systemd/user/ntfs-nag.service
rm /usr/libexec/ntfs_exfat_monitor_script

# tailscalery
systemctl enable tailscaled.service

# rebrandery
rm /usr/share/icons/hicolor/scalable/places/bazzite-logo.svg
rm /usr/share/icons/hicolor/scalable/places/bazzite-logo-white.svg
mv /usr/share/icons/hicolor/scalable/places/distributor-logo.svg /usr/share/icons/hicolor/scalable/places/bazzite-logo.svg
mv /usr/share/icons/hicolor/scalable/places/distributor-logo-white.svg /usr/share/icons/hicolor/scalable/places/bazzite-logo-white.svg
ln -s /usr/share/icons/hicolor/scalable/places/glorp-logo.svg /usr/share/icons/hicolor/scalable/places/distributor-logo.svg
ln -s /usr/share/icons/hicolor/scalable/places/glorp-logo-white.svg /usr/share/icons/hicolor/scalable/places/distributor-logo-white.svg

# releasery
sed -i "s/^NAME=.*/NAME=\"Glorp\"/" /usr/lib/os-release
sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"Glorp\"/" /usr/lib/os-release
sed -i "s/^LOGO=.*/LOGO=glorp-icon/" /usr/lib/os-release

# initramfsery
QUALIFIED_KERNEL="$(dnf5 repoquery --installed --queryformat='%{evr}.%{arch}' "kernel")"
/usr/bin/dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible --zstd -v --add ostree --add fido2 -f "/usr/lib/modules/$QUALIFIED_KERNEL/initramfs.img"
chmod 0600 /usr/lib/modules/"$QUALIFIED_KERNEL"/initramfs.img
