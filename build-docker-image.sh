vyosiso=`ls vyos-*-amd64.iso`
mkdir rootfs
mount -t iso9660 -o loop ${vyosiso} rootfs/
mkdir unsquashfs
unsquashfs -f -d unsquashfs/ rootfs/live/filesystem.squashfs

rm -rf unsquashfs/boot/*.img
rm -rf unsquashfs/boot/*vyos*
rm -rf unsquashfs/boot/vmlinuz
rm -rf unsquashfs/lib/firmware/
rm -rf unsquashfs/usr/lib/x86_64-linux-gnu/libwireshark.so*
rm -rf unsquashfs/lib/modules/*amd64-vyos

# don't know why but these will affect the host system, so delete them all
rm -f unsquashfs/usr/sbin/reboot
rm -f unsquashfs/usr/sbin/shutdown
rm -f unsquashfs/usr/sbin/halt
rm -f unsquashfs/usr/sbin/poweroff

kern_release=`uname -r`
cp -rp /lib/modules/${kern_release} unsquashfs/lib/modules

# change vyos default config
cp vyatta-config.boot.default unsquashfs/opt/vyatta/etc/config.boot.default
chown 0:0 unsquashfs/opt/vyatta/etc/config.boot.default

# docker scripts
mkdir -p unsquashfs/opt/docker-scripts
cp docker-scripts/* unsquashfs/opt/docker-scripts
chown -R 0:0  unsquashfs/opt/docker-scripts/*

cp docker-systemd/docker-script.service unsquashfs/etc/systemd/system/
chown 0:0 unsquashfs/etc/systemd/system/docker-script.service
ln -s /etc/systemd/system/docker-script.service unsquashfs/etc/systemd/system/vyos.target.wants/docker-script.service

tar -C unsquashfs -c . | docker import - vyos:test --change 'CMD ["/sbin/init"]'

rm -rf unsquashfs
umount rootfs
