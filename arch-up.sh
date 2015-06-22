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

echo 'Server = http://mirror.yandex.ru/archlinux/$repo/os/$arch' | cat - /etc/pacman.d/mirrorlist > temp && mv temp /etc/pacman.d/mirrorlist

pacstrap /mnt base base-devel
genfstab -U -p /mnt >> /mnt/etc/fstab

mv arch-env.sh /mnt/arch-env.sh
arch-chroot /mnt /bin/bash -c "sh ./arch-env.sh"
