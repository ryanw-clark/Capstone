

sudo apt install gpg apache2 mysql-server php php-intl php-mbstring php-xml php-apcu php-curl php-mysql
gpg --fetch-keys "https://www.mediawiki.org/keys/keys.txt"
wget https://releases.wikimedia.org/mediawiki/1.42/mediawiki-1.42.3.tar.gz
wget https://releases.wikimedia.org/mediawiki/1.42/mediawiki-1.42.3.tar.gz.sig
gpg --verify mediawiki-1.42.3.tar.gz.sig mediawiki-1.42.3.tar.gz
tar -xzvf mediawiki-*.tar.gz

sudo cp -r mediawiki-1.42.3 /var/www/html/mediawiki

sudo mysql -u root -p
CREATE DATABASE my_wiki;
CREATE USER 'wikiuser'@'localhost' IDENTIFIED BY 'capstone';
GRANT ALL PRIVILEGES ON my_wiki.* TO 'wikiuser'@'localhost' WITH GRANT OPTION;
quit;

sudo nvim /etc/apache2/sites-available/mediawiki.conf
<VirtualHost *:80>
    ServerName 10.2.1.251
    DocumentRoot /var/www/html/mediawiki
    <Directory /var/www/html/mediawiki/>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/mediawiki_error.log
    CustomLog ${APACHE_LOG_DIR}/mediawiki_access.log combined
</VirtualHost>

sudo chown -R www-data:www-data /var/www/html/mediawiki

sudo a2ensite mediawiki.conf
sudo a2dissite 000-default.conf
sudo a2enmod rewrite

sudo systemctl restart apache2

# to configure from browser
http://10.2.1.251/
sysadmin
capstone123

scp .\LocalSettings.php sysadmin@10.2.1.251:~/

sudo cp LocalSettings.php /var/www/html/mediawiki

sudo chown -R www-data:www-data /var/www/html/mediawiki

sudo nvim /var/www/html/mediawiki/LocalSettings.php
$wgSitename = 'pixelated protocol';
$wgDefaultSkin = 'minerva';

# Helpful
apachectl fullstatus
sudo apachectl configtest