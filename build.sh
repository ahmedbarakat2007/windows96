#!/bin/bash

echo "Let's Start"
cd rootfs

echo "Compressing Rootfs into init.cpio"

find . -print0 |
    cpio --null --create --verbose --owner root:root --format=newc |
    lz4c -l -9 > ../init.cpio


cd ..
echo "Moving Rootfs"
rm -f root/init.cpio
mv init.cpio root/init.cpio
cp bzImage root
echo "Making ISO"

mkisofs -o bootable.iso     -b boot/syslinux/isolinux.bin     -c boot/syslinux/boot.cat     -no-emul-boot -boot-load-size 4 -boot-info-table     -R -J -V "BOOTABLE_ISO" root

echo "Running the OS"
qemu-system-x86_64 -cdrom bootable.iso -net nic,model=e1000 -net user -m 1024M

