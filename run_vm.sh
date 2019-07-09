#!/bin/sh
IMAGE=/home/javierhonduco/qemu-image.img
KERNEL_PATH=/home/javierhonduco/local/linux
MNT_PATH=$KERNEL_PATH/tools/testing/selftests/bpf

qemu-system-x86_64 -kernel $KERNEL_PATH/arch/x86/boot/bzImage -drive file=$IMAGE,format=raw -nographic -append "console=ttyS0 root=/dev/sda rw single" -fsdev local,id=test_dev,path=$MNT_PATH,security_model=none -device virtio-9p-pci,fsdev=test_dev,mount_tag=test_mount -enable-kvm

# notes:
#   - on exit, with `Ctrl-A X` we regain the original tty
#   - mount -t 9p -o trans=virtio test_mount /root -oversion=9p2000.L,posixacl,cache=none
