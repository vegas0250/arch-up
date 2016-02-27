pacman -S apache php php-apache php-gd php-mcrypt php-pgsql mariadb postgresql nodejs npm --noconfirm
echo 'veemer ALL=(ALL) NOPASSWORD:ALL\n' | cat - /etc/sudoers > temp && mv temp /etc/sudoers
su veemer\n
cd ~\n
php -r 'readfile('https://getcomposer.org/installer');' > composer-setup.php\n
php composer-setup.php\n
php -r 'unlink('composer-setup.php');'\n
sudo mv composer.phar /usr/local/bin/composer\n