sudo systemctl stop mysqld
sudo chattr +C /var/lib/mysql
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl start mysqld
mysql_secure_installation

sudo su - postgres -c "initdb --locale ru_RU.UTF-8 -E UTF8 -D '/var/lib/postgres/data'"

cd ~
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

mkdir ~/.npm-global
npm config set prefix '~/.npm-global'

echo -e "export PATH=~/.npm-global/bin:$PATH" > ~/.bash
source ~/.bash