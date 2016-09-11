#!/bin/bash
set -e -x
find /result -type f | xargs rm -fv
mkdir /tmp/work
cd /tmp/work
cp -av /config/* /tmp/work

# create grub config redirects
mkdir -p EFI/ubuntu
cat >EFI/ubuntu/grub.cfg <<EOF
# switch to the BIOS-grub grub.cfg file
set prefix=(\$root)/boot/grub
configfile (\$root)/grub.cfg
EOF

# add efi boot loader. Somehow the automatic mode yields a "Partition not found!" message when booting in BIOS mode from USB storage. Solution is to force grub-mkrescue to only use i386-pc and adding grub as all-in-one binary to the generic efi boot location
mkdir -p EFI/BOOT
cp -v /usr/lib/grub/x86_64-efi-signed/grubx64.efi.signed EFI/BOOT/BOOTX64.EFI

mkdir -p boot/grub
cat >boot/grub/grub.cfg <<EOF
configfile (\$root)/grub.cfg
EOF

grub-mkrescue -d /usr/lib/grub/i386-pc -o /result/${1:-jts}.iso . -- -volid ${2:-JTS_INSTALL}
chown --reference /result --recursive /result
ls -l /result
