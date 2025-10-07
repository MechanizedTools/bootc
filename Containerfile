FROM scratch AS ctx

COPY /filesystem /filesystem
COPY /scripts /scripts


FROM quay.io/fedora/fedora-bootc:42

LABEL org.opencontainers.image.source="https://github.com/MechanizedTools/bootc"
LABEL containers.bootc=1
LABEL ostree.bootable=1

ENV container=oci

RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    /ctx/scripts/build.sh
