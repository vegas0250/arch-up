
echo 'Install part 1: parted dev'
parted /dev/sda mklabel msdos > /dev/null
parted /dev/sda mkpart primary ext4 1M 100M > /dev/null
parted /dev/sda set 1 boot on > /dev/null
parted /dev/sda mkpart primary linux-swap 100M 2G > /dev/null
parted /dev/sda mkpart primary ext4 2G 100% > /dev/null

echo 'Install part 2: format dev'
mkfs.ext4 /dev/sda1 > /dev/null
mkfs.ext4 /dev/sda3 > /dev/null

echo 'Install part 3: make swap'
mkswap /dev/sda2 > /dev/null
swapon /dev/sda2 > /dev/null

echo 'Install part 4: mount dev'
mount /dev/sda3 /mnt > /dev/null
mkdir -p /mnt/boot > /dev/null
mount /dev/sda1 /mnt/boot > /dev/null

echo 'Install part 5: set relevant mirror'
echo 'Server = http://mirror.yandex.ru/archlinux/$repo/os/$arch' | cat - /etc/pacman.d/mirrorlist > temp && mv temp /etc/pacman.d/mirrorlist

echo 'Install part 6: sed inetutils linux pacman'
pacstrap -i /mnt sed inetutils linux pacman
genfstab -U -p /mnt >> /mnt/etc/fstab

echo 'Install part 7: env-up'
mv test2.sh /mnt/test2.sh
arch-chroot /mnt /bin/bash -c "sh ./test2.sh"
