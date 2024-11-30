
sudo apt install samba
sudo nvim /etc/samba/smb.conf

[linux-share]
        path = /srv/samba/linux-share
        browseable = yes
        read only = no
        guest ok = yes

sudo chown -R nobody:nogroup /srv/samba/linux-share

\\10.2.1.251\linux-share