echo 'Install part 1: parted dev'
echo -e "
mklabel msdos\n
mkpart primary ext4 1M 100M\n
mkpart primary linux-swap 100M 1G\n
mkpart primary ext4 1G 100%\n
set 1 boot on\n
" | parted /dev/sda 2>&1 1>/dev/null

echo 'Install part 2: format dev'
mkfs.ext4 /dev/sda1 > /dev/null
mkfs.ext4 /dev/sda3 > /dev/null
mkswap /dev/sda2 > /dev/null
swapon /dev/sda2 > /dev/null

echo 'Install part 3: mount dev'
mount /dev/sda3 /mnt > /dev/null
mkdir -p /mnt/boot > /dev/null
mount /dev/sda1 /mnt/boot > /dev/null

echo 'Install part 5: set relevant mirror'
echo 'Server = http://mirror.yandex.ru/archlinux/$repo/os/$arch' | cat - /etc/pacman.d/mirrorlist > temp && mv temp /etc/pacman.d/mirrorlist

echo 'Install part 6: sed inetutils linux pacman'
pacstrap /mnt base base-devel
genfstab -U -p /mnt >> /mnt/etc/fstab

echo 'Install part 7: env-up'

mv vm-env.sh /mnt/vm-env.sh
# arch-chroot /mnt /bin/bash
arch-chroot /mnt /bin/bash -c "sh ./vm-env.sh"

# systemctl reboot