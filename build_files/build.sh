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
