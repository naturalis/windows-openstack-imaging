WIN_ISO=Software/SERV2008R2UK.iso
IMAGE=Images/windows-2008-base.raw
SOFTWARE_ISO=Software/Software.iso
KVM=/usr/libexec/qemu-kvm

if [ ! -f "$KVM" ]; then
  KVM=/usr/bin/kvm
fi

if [ ! -f "$IMAGE" ]; then
  qemu-img create -f raw $IMAGE 60G
fi

$KVM \
-m 2048 \
-cdrom $WIN_ISO \
-drive file=$IMAGE,if=virtio \
-drive file=$SOFTWARE_ISO,index=3,media=cdrom \
-net nic,model=virtio \
-net user \
-nographic \
-boot d \
-vga std \
-k en-us \
-vnc :1 \
-usbdevice tablet
