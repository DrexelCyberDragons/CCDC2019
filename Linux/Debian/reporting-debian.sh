### Debian ntp

sudo apt-get install ntp ntpdate -y
sudo systemctl start ntp
sudo systemctl enable ntp
sudo ntpdate -q 0.rhel.pool.ntp.org
sudo timedatectl set-timezone "America/New_York"
sudo systemctl restart ntp

### Debian auditd

sudo apt-get install auditd -y
sudo rm -rf /etc/audit/rules.d/audit.rules
sudo mv audit.rules /etc/audit/rules.d/
sudo systemctl start auditd
sudo systemctl enable auditd

### Fail2Ban

sudo apt-get install fail2ban -y
sudo systemctl start fail2ban
sudo systemctl enable fail2ban
