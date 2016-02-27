sudo systemctl stop mysqld
sudo chattr +C /var/lib/mysql
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql 1>/dev/null
sudo systemctl start mysqld
mysql_secure_installation

sudo su - postgres -c "initdb --locale ru_RU.UTF-8 -E UTF8 -D '/var/lib/postgres/data'"
sudo -u postgres sed -i 's/127.0.0.1\/32/0.0.0.0\/0/g' /var/lib/postgres/data/pg_hba.conf
sudo -u postgres sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/postgres/data/postgresql.conf

mysql --user="root" --password="veemer" --execute="GRANT ALL ON *.* TO root@'*' IDENTIFIED BY 'veemer';"

cd ~
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

mkdir ~/.npm-global
npm config set prefix '~/.npm-global'

echo -e "export PATH=~/.npm-global/bin:$PATH" > ~/.bash
source ~/.bash