### Starter script

## Create sudoer account & disable root

useradd alfonzo
echo "cyberdragons\ncyberdragons" | passwd alfonzo
useradd sam
echo "cyberdragons\ncyberdragons" | passwd sam
useradd colbert
echo "cyberdragons\ncyberdragons" | passwd colbert
useradd nick
echo "cyberdragons\ncyberdragons" | passwd nick

usermod -aG sudo alfonzo
usermod -aG sudo sam
usermod -aG sudo colbert
usermod -aG sudo nick

sudo passwd -ld root

sudo passwd -aS | grep " P \| NP " > passenabled.txt

## Tools

sudo apt-get upgrade -y
sudo apt-get update -y
sudo apt-get install vim -y
