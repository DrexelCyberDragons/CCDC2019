### Starter script

useradd alfonzo
passwd alfonzo
usermod -aG wheel alfonzo

useradd sam
passwd sam
usermod -aG wheel sam

useradd colbert
passwd colbert
usermod -aG wheel colbert

useradd nick
passwd nick
usermod -aG wheel nick

su alfonzo
sudo passwd -l root
sudo passwd -d root

## Tools

sudo yum upgrade -y
sudo yum update -y
sudp yum install vim -y
