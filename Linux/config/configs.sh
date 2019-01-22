### Patch config files

### sshd_config

diff /etc/ssh/sshd_config sshd_config > sshd.patch
patch /etc/ssh/ssh_config < sshd.patch

### skel replacement

rm -rf /etc/skel
mv skel /etc/

### bashrc replacement

rm -rf /etc/bashrc
rm -rf /etc/bash.bashrc
mv bashrc /etc/
mv bash.bashrc /etc/
