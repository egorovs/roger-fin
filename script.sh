#!/bin/bash

apt-get install vim sudo -y
apt-get update -y && apt-get upgrade -y
sudo cp ./gcaitlyn/roger-files/interfaces /etc/network/interfaces
sudo service networking restart
sudo cp ./gcaitlyn/roger-files/sshd_config /etc/ssh/sshd_config
sudo service sshd restart
sudo apt-get install ufw -y
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 55555/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443
sudo apt-get install iptables fail2ban apache2 -y
sudo cp ./gcaitlyn/roger-files/jail.local /etc/fail2ban/jail.local
sudo cp ./gcaitlyn/roger-files/http-get-dos.conf /etc/fail2ban/filter.d/http-get-dos.conf
sudo ufw reload
sudo ufw status verbose
sudo service fail2ban restart
sudo apt-get install portsentry -y
sudo cp ./gcaitlyn/roger-files/portsentry /etc/default/portsentry
sudo cp ./gcaitlyn/roger-files/portsentry.conf /etc/portsentry/portsentry.conf
sudo cp ./gcaitlyn/roger-files/update.sh ./update.sh
(sudo crontab -l -u root; echo "@reboot /home/r-gcaitlyn/update.sh &") | sudo crontab -
(sudo crontab -l -u root; echo "0 0 * * * /home/r-gcaitlyn/update.sh &") | sudo crontab -
sudo cp ./gcaitlyn/roger-files/cronchk.sh ./cronchk.sh
(sudo crontab -l -u root; echo "* * * * * /home/r-gcaitlyn/cronchk.sh &") | sudo crontab -
sudo apt install bsd-mailx -y
sudo apt install postfix -y
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Local only'"
debconf-set-selections <<< "postfix postfix/mailname string 'debian.lan'"
sudo cp ./gcaitlyn/roger-files/aliases /etc/aliases
sudo newaliases
sudo postconf -e "home_mailbox = mail/"
sudo service postfix restart
sudo apt install mutt -y
sudo cp ./gcaitlyn/roger-files/.muttrc /root/.muttrc
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
sudo cp ./gcaitlyn/roger-files/ssl-params.conf /etc/apache2/conf-available/ssl-params.conf
sudo cp ./gcaitlyn/roger-files/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
sudo cp ./gcaitlyn/roger-files/000-default.conf /etc/apache2/sites-available/000-default.conf
sudo a2enmod ssl
sudo a2enmod headers
sudo a2ensite default-ssl
sudo a2enconf ssl-params
sudo apache2ctl configtest
sudo systemctl restart apache2

