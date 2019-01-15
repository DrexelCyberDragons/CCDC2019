### Starter script

useradd alfonzo
passwd alfonzo
usermod -aG wheel alfonzo

useradd sam
passwd sam
usermod -aG wheel sam

su alfonzo
sudo passwd -l root
sudo passwd -d root
