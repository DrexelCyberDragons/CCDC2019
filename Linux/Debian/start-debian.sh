### Starter script

## Create sudoer account & disable root

adduser --gecos "" alfonzo
adduser --gecos "" sam
adduser --gecos "" colbert
adduser --gecos "" nick

usermod -aG sudo alfonzo
usermod -aG sudo sam
usermod -aG sudo colbert
usermod -aG sudo nick

su alfonzo

sudo passwd -ld root

sudo passwd -aS | grep " P \| NP " > passenabled.txt

## Tools

sudo apt-get upgrade -y
sudo apt-get update -y
sudo apt-get install vim -y
