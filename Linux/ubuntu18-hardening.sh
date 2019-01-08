###Ubuntu18

##Notes
#ssh -t
#rm -rf .bashrc .bashprofile .profile

##Installing and Activating AppArmor
sudo apt-get upgrade && apt-get update -yuf
sudo apt-get install apparmor-utils apparmor-profiles apparmor-profiles-extra -y
sudo systemctl enable apparmor
sudo systemctl start apparmor
sudo aa-enforce /etc/apparmor.d/*

##Installing and Activating ModSecurity
sudo apt-get install libapache2-mod-security2 -y
##Check if ModSecurity success (security2_modue (shared))
#sudo apachectl -M | grep --color security2
sudo mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
##Reload Apache2
#sudo service apache2 start
#sudo service apache2 restart
sudo service apache2 reload
##Turning on SecRuleEngine
sudo sed -i "s/SecRuleEngine DetectionOnly/SecRuleEngine On/" /etc/modsecurity/modsecurity.conf
##Replace ModSecurity folder with OWASP's modsecurity config

sudo mv /usr/share/modsecurity-crs /usr/share/modsecurity-crs.bk
sudo git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git /usr/share/modsecurity-crs
sudo cp /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf
##Clobber ModSecurity Default conf with updated conf
sudo mv security2patch.conf /etc/apache2/mods-enabled/security2.conf
sudo systemctl restart apache2

##Patch sshd_config
sudo diff sshd_config /etc/ssh/sshd_config > sshd_config.patch
sudo patch -l /etc/ssh/sshd_config sshd_config.patch

##Check accounts for Empty passwords
sudo cat /etc/shadow | awk -F: '($2==""){print $1}' > ~/emptypasswords.txt

##Disable IPv6
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -p

##Patch Network to

##Install ntp
sudo apt-get install ntp ntpdate -y
sudo systemctl start ntp
sudo systemctl enable ntp
sudo ntpdate -q 0.rhel.pool.ntp.org
sudo timedatectl set-timezone "America/New_York"
sudo systemctl restart ntp
