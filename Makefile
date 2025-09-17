OCI_IMAGE ?= ghcr.io/mechanizedtools/bootc:latest
ROOTFS ?= btrfs

.PHONY: build-image
build-image:
	podman build -t $(OCI_IMAGE) .

.PHONY: push-image
push-image:
	podman push $(OCI_IMAGE)

.PHONY: qcow2-image
qcow2-image:
	[ -d output ] || mkdir output
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
		--rootfs $(ROOTFS) \
		--use-librepo=True \
		$(OCI_IMAGE)

.PHONY: anaconda-image
anaconda-image:
	[ -d output ] || mkdir output
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
		--rootfs $(ROOTFS) \
		--use-librepo=True \
		$(OCI_IMAGE)

.PHONY: test-image
test-image:
	qemu-system-x86_64 \
		-M accel=kvm \
		-cpu host \
		-smp 2 \
		-m 4096 \
		-bios /usr/share/OVMF/OVMF_CODE.fd \
		-serial stdio \
		-snapshot output/qcow2/disk.qcow2

.PHONY: test-install
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
