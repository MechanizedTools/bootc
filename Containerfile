FROM quay.io/fedora/fedora-bootc:42

LABEL org.opencontainers.image.source="https://github.com/MechanizedTools/bootc"
LABEL containers.bootc=1
LABEL ostree.bootable=1

ENV container=oci

COPY bootc/kargs/10-plymouth.toml /usr/lib/bootc/kargs.d/10-plymouth.toml

RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                   https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf install -y @gnome-desktop \
                   atop \
                   distrobox \
                   fedora-release-cosmic-atomic \
                   fido2-tools \
                   htop \
                   iwlwifi-dvm-firmware \
                   iwlwifi-mvm-firmware \
                   just \
                   mpv \
                   NetworkManager-bluetooth \
                   NetworkManager-wifi \
                   pam-u2f pamu2fcfg \
                   plymouth \
                   plymouth-system-theme \
                   setools-console \
                   syncthing syncthing-tools \
                   xclip \
                   ykpers yubikey-manager \
                   zsh \
 && dnf remove -y nano nano-default-editor \
 && dnf clean all \
 && rm -rf /var/{log,cache,lib}/*

RUN plymouth-set-default-theme -R spinner

RUN systemctl set-default graphical.target

RUN bootc container lint
