chattr +C /var/lib/mysql
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
systemctl start mysqld
mysql_secure_installation

sudo su - postgres -c "initdb --locale ru_RU.UTF-8 -E UTF8 -D '/var/lib/postgres/data'"

# sudo -u veemer cd ~
# sudo -u veemer php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
# sudo -u veemer php composer-setup.php
# sudo -u veemer php -r "unlink('composer-setup.php');"
# sudo -u veemer sudo mv composer.phar /usr/local/bin/composer

# sudo -u veemer mkdir ~/.npm-global
# sudo -u veemer npm config set prefix '~/.npm-global'

# sudo -u veemer echo -e "export PATH=~/.npm-global/bin:$PATH" > ~/.bash
# sudo -u veemer source ~/.bash