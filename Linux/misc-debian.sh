###Miscellaneous (Debian)

##Disable IPv6
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -p

##Check accounts for Empty passwords
sudo cat /etc/shadow | awk -F: '($2==""){print $1}' > ~/emptypasswords.txt

##Patch sshd_config
sudo diff sshd_config /etc/ssh/sshd_config > sshd_config.patch
sudo patch -l /etc/ssh/sshd_config sshd_config.patch
