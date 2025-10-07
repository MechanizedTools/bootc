#!/usr/bin/bash

set -eoux pipefail

mkdir -p -m 0700 /var/roothome

cp -rfv /ctx/filesystem/* /

dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
               https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf install -y @gnome-desktop \
               atop \
               distrobox \
               fedora-release-cosmic-atomic \
               fido2-tools \
               htop \
               intel-gpu-firmware \
               iwlwifi-dvm-firmware \
               iwlwifi-mvm-firmware \
               just \
               mpv \
               NetworkManager-bluetooth \
               NetworkManager-wifi \
               pam-u2f pamu2fcfg \
               plymouth \
               plymouth-system-theme \
	       qemu-guest-agent \
               setools-console \
               syncthing syncthing-tools \
               vhost-device-gpu \
               xclip \
               ykpers yubikey-manager \
               zsh

dnf remove -y nano nano-default-editor
dnf clean all

plymouth-set-default-theme spinner

kver=$(ls /usr/lib/modules)
DRACUT_NO_XATTR=1 dracut -vf /usr/lib/modules/$kver/initramfs.img "$kver"

systemctl enable firstboot.service
systemctl set-default graphical.target

rm -rf /var/{log,lib}/*
rm -rf /var/roothome

bootc container lint
