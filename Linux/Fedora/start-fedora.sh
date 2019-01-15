### Starter script

useradd alfonzo
echo "cyberdragons" | passwd alfonzo --stdin
usermod -aG wheel alfonzo

useradd sam
echo "cyberdragons" | passwd sam --stdin
usermod -aG wheel sam

useradd colbert
echo "cyberdragons" | passwd colbert --stdin
usermod -aG wheel colbert

useradd nick
echo "cyberdragons" | passwd nick --stdin
usermod -aG wheel nick

su alfonzo
sudo passwd -l root
sudo passwd -d root

## Tools

sudo yum upgrade -y
sudo yum update -y
sudosud yum install vim -y
