echo 'Install part 1: parted dev'
echo -e "
mklabel msdos\n
mkpart primary ext4 1M 100M\n
mkpart primary linux-swap 100M 2G\n
mkpart primary ext4 2G 100%\n
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
pacstrap /mnt base
genfstab -U -p /mnt >> /mnt/etc/fstab

echo 'Install part 7: env-up'

echo -e "
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen\n
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/g' /etc/locale.gen\n
locale-gen\n
echo LANG=en_US.UTF-8 > /etc/locale.conf\n
export LANG=en_US.UTF-8\n
echo -e 'KEYMAP=ru\nFONT=cyr-sun16' > /etc/vconsole.conf\n
ln -s /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime\n
hwclock --systohc --utc\n
echo delta > /etc/hostname\n
echo -e '#<ip-address> <hostname.domain.org> <hostname>\n127.0.0.1 localhost.localdomain localhost delta\n::1   localhost.localdomain localhost delta' > /etc/hosts\n
mkinitcpio -p linux\n
pacman -S grub\n
grub-install --target=i386-pc --recheck /dev/sda\n
grub-mkconfig -o /boot/grub/grub.cfg\n
" > vm_env.sh

mv vm_env.sh /mnt/vm_env.sh
# arch-chroot /mnt /bin/bash
arch-chroot /mnt /bin/bash -c "sh ./vm_env.sh"
