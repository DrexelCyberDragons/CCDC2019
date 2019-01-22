### Starter script

## Create sudoer account & disable root

useradd alfonzo -s /bin/bash
echo -e "cyberdragons\ncyberdragons" | passwd alfonzo
useradd sam -s /bin/bash
echo -e "cyberdragons\ncyberdragons" | passwd sam
useradd colbert -s /bin/bash
echo -e "cyberdragons\ncyberdragons" | passwd colbert
useradd nick -s /bin/bash
echo -e "cyberdragons\ncyberdragons" | passwd nick

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
