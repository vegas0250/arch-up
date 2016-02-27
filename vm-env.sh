sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
echo -e 'KEYMAP=ru\nFONT=cyr-sun16' > /etc/vconsole.conf
ln -s /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
hwclock --systohc --utc
echo delta > /etc/hostname
echo -e '#<ip-address> <hostname.domain.org> <hostname>\n127.0.0.1 localhost.localdomain localhost delta\n::1   localhost.localdomain localhost delta' > /etc/hosts
mkinitcpio -p linux
pacman -S grub apache php php-apache php-gd php-mcrypt php-pgsql mariadb postgresql nodejs npm git --quiet --noconfirm
useradd -m veemer
echo -e 'veemer\nveemer' | passwd
echo -e 'veemer\nveemer' | passwd veemer

systemctl enable dhcpcd
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
echo 'veemer ALL=(ALL) PASSWD:ALL\n' | cat - /etc/sudoers > temp && mv temp /etc/sudoers

sudo -u veemer cd ~
sudo -u veemer php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
sudo -u veemer php composer-setup.php
sudo -u veemer php -r "unlink('composer-setup.php');"
sudo -u veemer sudo mv composer.phar /usr/local/bin/composer

sudo -u veemer mkdir ~/.npm-global
sudo -u veemer npm config set prefix '~/.npm-global'

sudo -u veemer echo -e "export PATH=~/.npm-global/bin:$PATH" > ~/.bash
sudo -u veemer source ~/.bash