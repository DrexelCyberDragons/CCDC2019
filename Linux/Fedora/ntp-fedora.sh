### Fedora ntp

sudo yum install ntp ntpdate -y
sudo systemctl start ntpd
sudo systemctl enable ntpd
sudo ntpdate -q 0.rhel.pool.ntp.org
sudo timedatectl set-timezone "America/New_York"
sudo systemctl restart ntpd
