OCI_IMAGE := "ghcr.io/mechanizedtools/bootc:latest"
ROOTFS := "btrfs"

# Build OCI image
build-image:
    sudo podman build -t {{OCI_IMAGE}} .

# Push OCI image
push-image:
    sudo podman push {{OCI_IMAGE}}

# Build qcow2 image
qcow2-image:
    mkdir -p output
    sudo podman run \
        --rm \
        -it \
        --privileged \
        --pull=newer \
        --security-opt label=type:unconfined_t \
        -v ./config.toml:/config.toml:ro \
        -v ./output:/output \
        -v /var/lib/containers/storage:/var/lib/containers/storage \
        quay.io/centos-bootc/bootc-image-builder:latest \
        --type qcow2 \
        --rootfs {{ROOTFS}} \
        --use-librepo=True \
        {{OCI_IMAGE}}

# Build Anaconda install ISO
anaconda-image:
    mkdir -p output
    sudo podman run \
        --rm \
        -it \
        --privileged \
        --pull=newer \
        --security-opt label=type:unconfined_t \
        -v ./config.toml:/config.toml:ro \
        -v ./output:/output \
        -v /var/lib/containers/storage:/var/lib/containers/storage \
        quay.io/centos-bootc/bootc-image-builder:latest \
        --type anaconda-iso \
        --rootfs {{ROOTFS}} \
        --use-librepo=True \
        {{OCI_IMAGE}}

# Test qcow2 image in QEMU
test-image:
    qemu-system-x86_64 \
        -M accel=kvm \
        -cpu host \
        -smp 2 \
        -m 4096 \
        -bios /usr/share/OVMF/OVMF_CODE.fd \
        -serial stdio \
        -snapshot output/qcow2/disk.qcow2

# Test Anaconda install ISO in QEMU
test-install:
    qemu-system-x86_64 \
        -M accel=kvm \
        -cpu host \
        -smp 2 \
        -m 4096 \
        -bios /usr/share/OVMF/OVMF_CODE.fd \
        -serial stdio \
        -hdc output/test-disk.qcow2 \
        -cdrom output/bootiso/install.iso
