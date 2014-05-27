WIN_ISO=Software/SW_DVD9_Windows_Svr_Std_and_DataCtr_2012_R2_64Bit_English_-2_Core_MLF_X19-31419.ISO
IMAGE=Images/win-2012-01.raw
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
