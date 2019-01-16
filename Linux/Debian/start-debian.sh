### Starter script

## Create sudoer account & disable root

useradd alfonzo
#(echo "cyberdragons" & "cyberdragons") | passwd alfonzo
passwd alfonzo
useradd sam
#(echo "cyberdragons" & "cyberdragons") | passwd sam
passwd sam
useradd colbert
#(echo "cyberdragons" & "cyberdragons") | passwd colbert
passwd colbert
useradd nick
#(echo "cyberdragons" & "cyberdragons") | passwd nick
passwd nick

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
