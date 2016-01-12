sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/g' /etc/locale.gen

locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

echo -e "KEYMAP=ru\nFONT=cyr-sun16" > /etc/vconsole.conf

ln -s /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
hwclock --systohc --utc

echo delta > /etc/hostname
echo -e "#<ip-address> <hostname.domain.org> <hostname>\n127.0.0.1 localhost.localdomain localhost delta\n::1   localhost.localdomain localhost delta" > /etc/hosts

mkinitcpio -p linux

pacman -S grub
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
