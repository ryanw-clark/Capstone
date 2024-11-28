

wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu24.04_all.deb
sudo dpkg -i zabbix-release_latest+ubuntu24.04_all.deb
sudo apt update

sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

sudo mysql -u root -p
create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by 'capstone';
grant all privileges on zabbix.* to zabbix@localhost;
set global log_bin_trust_function_creators = 1;
quit;

sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix

sudo mysql -u root -p
set global log_bin_trust_function_creators = 0;
quit; 

sudo nvim /etc/zabbix/zabbix_server.conf
DBPassword=capstone

sudo nvim /etc/apache2/sites-available/zabbix.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /usr/share/zabbix

    <Directory "/usr/share/zabbix">
        Options FollowSymLinks
        AllowOverride None
        Require all granted

        <IfModule mod_php.c>
            php_value max_execution_time 300
            php_value memory_limit 128M
            php_value post_max_size 16M
            php_value upload_max_filesize 2M
            php_value max_input_time 300
            php_value max_input_vars 10000
            php_value always_populate_raw_post_data -1
            php_value date.timezone America/Los_Angeles
        </IfModule>
    </Directory>

    <Directory "/usr/share/zabbix/conf">
        Require all denied
    </Directory>

    <Directory "/usr/share/zabbix/app">
        Require all denied
    </Directory>

    <Directory "/usr/share/zabbix/include">
        Require all denied
    </Directory>

    <Directory "/usr/share/zabbix/local">
        Require all denied
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/zabbix_error.log
    CustomLog ${APACHE_LOG_DIR}/zabbix_access.log combined
</VirtualHost>

sudo a2ensite zabbix.conf

sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2

username: Admin
password: zabbix