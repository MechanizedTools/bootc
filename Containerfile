FROM quay.io/fedora/fedora-bootc:42
LABEL org.opencontainers.image.source="https://github.com/MechanizedTools/bootc"

RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                   https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf install -y @cosmic-desktop \
                   atop \
                   distrobox \
                   fedora-release-cosmic-atomic \
                   fido2-tools \
                   mpv \
                   NetworkManager-bluetooth \
                   NetworkManager-wifi \
                   pam-u2f pamu2fcfg \
                   setools-console \
                   syncthing syncthing-tools \
                   xclip \
                   ykpers yubikey-manager \
                   zsh \
 && dnf remove -y nano nano-default-editor \
 && dnf clean all \
 && rm -f /var/log/dnf5.log*

RUN systemctl set-default graphical.target

RUN bootc container lint
