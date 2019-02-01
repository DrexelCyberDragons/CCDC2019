### Patch config files

### sshd_config

diff /etc/ssh/sshd_config ~/config/sshd_config > sshd.patch
patch /etc/ssh/sshd_config < sshd.patch
systemctl restart sshd

### bashrc replacement

rm -rf /etc/bashrc
rm -rf /etc/bash.bashrc
mv ~/config/bashrc /etc/
mv ~/config/bash.bashrc /etc/

## vsftp.conf replacement

#rm -rf /etc/vsftpd.conf
#mv vsftp.conf /etc/
#diff /etc/vsftpd.conf ~/config/vsftpd.conf > vsftpd.patch
#patch /etc/vsftpd.conf < vsftpd.patch
#systemctl restart vsftpd

#disable ipv6 sysctl

echo "net.ipv6.conf.all.disable_ipv6 = 1" >>  /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

## check mitre attack framework
