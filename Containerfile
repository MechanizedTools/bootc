FROM quay.io/fedora/fedora-bootc:42
LABEL org.opencontainers.image.source="https://github.com/MechanizedTools/bootc"

RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                   https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf install -y pam-u2f pamu2fcfg setools-console syncthing syncthing-tools xclip ykpers yubikey-manager zsh \
 && dnf clean all

RUN systemctl set-default graphical.target
RUN bootc container lint
