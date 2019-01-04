##Install ntp
sudo apt-get install ntp ntpdate -y
sudo systemctl start ntp
sudo systemctl enable ntp
sudo ntpdate -q 0.rhel.pool.ntp.org
sudo timedatectl set-timezone "America/New_York"
sudo systemctl restart ntp 
