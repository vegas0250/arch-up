parted /dev/sda mklabel msdos
parted /dev/sda mkpart primary ext4 1M 100M
parted /dev/sda set 1 boot on
parted /dev/sda mkpart primary linux-swap 100M 2G
parted /dev/sda mkpart primary ext4 2G 100%

mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda3

mkswap /dev/sda2
swapon /dev/sda2

mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

pacstrap /mnt base base-devel
genfstab -U -p /mnt >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash

echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
echo 'ru_RU.UTF-8 UTF-8' > /etc/locale.gen

locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

echo KEYMAP=ru > /etc/vconsole.conf
echo FONT=cyr-sun16 > /etc/vconsole.conf

ln -s /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
hwclock --systohc --utc

echo delta > /etc/hostname

systemctl enable dhcpcd@enp0s3.service

mkinitcpio -p linux

toor | passwd

pacman -S grub
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
exit
umount -R /mnt