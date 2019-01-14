### Starter script

## Create sudoer account & disable root

adduser --gecos "" alfonzo
adduser --gecos "" sam

usermod -aG sudo alfonzo
usermod -aG sudo sam
su alfonzo

sudo passwd -ld root

sudo passwd -aS | grep " P \| NP " > passenabled.txt
