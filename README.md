test
====

Créer image qcow2 :

```
make qcow2-image
```

Lancer avec qemu :

```
qemu-system-x86_64 \
    -M accel=kvm \
    -cpu host \
    -smp 2 \
    -m 4096 \
    -bios /usr/share/OVMF/OVMF_CODE.fd \
    -serial stdio \
    -snapshot output/qcow2/disk.qcow2
```

Lancer avec libvirt :

```
sudo virt-install \
    --name fedora-bootc \
    --cpu host \
    --vcpus 4 \
    --memory 4096 \
    --import --disk ./output/qcow2/disk.qcow2,format=qcow2 \
    --os-variant fedora-eln
```

install
=======

Créer une image iso d'installation

```
make anaconda-image
```
