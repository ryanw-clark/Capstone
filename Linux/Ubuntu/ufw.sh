# After programs are installed
sudo ufw enable
sudo ufw allow OpenSSH
sudo ufw allow "Apache Full"
sudo ufw allow Samba
sudo ufw status

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere
Apache Full                ALLOW       Anywhere
Samba                      ALLOW       Anywhere
OpenSSH (v6)               ALLOW       Anywhere (v6)
Apache Full (v6)           ALLOW       Anywhere (v6)
Samba (v6)                 ALLOW       Anywhere (v6)