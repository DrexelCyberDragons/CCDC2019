### Starter script

### Create sudoer account & disable root

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

### Password Changes

for i in $( cat /etc/passwd | awk -F: '$3 > 999 {print $1}' ); do
	echo -e "cyberdragons\ncyberdragons" | passwd $i
done

### Remove sudoers

grep '^sudo:.*$' /etc/group | cut -d: -f4 | sed "s/,/\n/g" > sudo.bk

for i in $(grep '^sudo:.*$' /etc/group | cut -d: -f4 | sed "s/,/\n/g"); do
	if [ "$i" = "alfonzo" ] ; then
		continue
	elif [ "$i" = "sam" ] ; then
		continue
	elif [ "$i" = "nick" ] ; then
		continue
	elif [ "$i" = "colbert" ] ; then
		continue
	else
		deluser $i sudo
	fi
done

### No login

cat /etc/passwd | awk -F: '$7 != "/usr/sbin/nologin" {print $1}' > bash.bk

for i in $( cat /etc/passwd | awk -F: '$7 != "/usr/sbin/nologin" {print $1}' ); do
  if [ "$i" = "alfonzo" ] ; then
    continue
  elif [ "$i" = "sam" ] ; then
    continue
  elif [ "$i" = "nick" ] ; then
    continue
  elif [ "$i" = "colbert" ] ; then
    continue
  elif [ "$i" = "root" ] ; then
    continue
  else
    usermod -s /usr/sbin/nologin $i
  fi
done

### Tools

sudo apt-get upgrade -y
sudo apt-get update -y
sudo apt-get install vim -y
