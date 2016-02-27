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
pacman -S grub openssh apache xdebug virtualbox-guest-utils php php-apache php-gd php-mcrypt php-pgsql mariadb postgresql nodejs npm git --noconfirm

echo -e "
vboxguest\n
vboxsf\n
vboxvideo\n
" > /etc/modules-load.d/virtualbox.conf

echo "www   /srv/http    vboxsf  uid=user,gid=group,rw,comment=systemd.automount 0 0" | cat - /etc/fstab > temp && mv temp /etc/fstab
echo "vhost   /srv/vhost    vboxsf  uid=user,gid=group,rw,comment=systemd.automount 0 0" | cat - /etc/fstab > temp && mv temp /etc/fstab

useradd -m veemer
echo -e 'veemer\nveemer' | passwd
echo -e 'veemer\nveemer' | passwd veemer

echo 'veemer ALL=(ALL) NOPASSWD:ALL' | cat - /etc/sudoers > temp && mv temp /etc/sudoers

sed -i 's/LoadModule mpm_event_module modules\/mod_mpm_event.so/LoadModule mpm_prefork_module modules\/mod_mpm_prefork.so/g' /etc/httpd/conf/httpd.conf
sed -i 's/LoadModule dir_module modules\/mod_dir.so/LoadModule dir_module modules\/mod_dir.so\nLoadModule php7_module modules\/libphp7.so/g' /etc/httpd/conf/httpd.conf
sed -i 's/Include conf\/extra\/httpd-default.conf/Include conf\/extra\/httpd-default.conf\nInclude conf\/extra\/php7_module.conf/g' /etc/httpd/conf/httpd.conf
sed -i 's/;date.timezone =/date.timezone = Europe\/Moscow/g' /etc/php/php.ini
sed -i 's/display_errors=Off/display_errors=On/g' /etc/php/php.ini
sed -i 's/#extension=gd.so/extension=gd.so/g' /etc/php/php.ini
sed -i 's/#extension=mcrypt.so/extension=mcrypt.so/g' /etc/php/php.ini
sed -i 's/#extension=pdo_mysql.so/extension=pdo_mysql.so/g' /etc/php/php.ini
sed -i 's/#extension=mysqli.so/extension=mysqli.so/g' /etc/php/php.ini
sed -i 's/#extension=pdo_pgsql.so/extension=pdo_pgsql.so/g' /etc/php/php.ini
sed -i 's/#extension=pgsql.so/extension=pgsql.so/g' /etc/php/php.ini
sed -i 's/#extension=xdebug.so/extension=xdebug.so/g' /etc/php/php.ini

systemctl enable dhcpcd
systemctl enable sshd
systemctl enable mysqld
systemctl enable postgresql

grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

systemctl reboot