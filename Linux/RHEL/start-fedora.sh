### Starter script

### Wipe /etc/skel

rm -rf /etc/skel
mv ../config/skel /etc/

### Create our user accounts

useradd alfonzo
echo -e "dustyspicy50\ndustyspicy50" | passwd alfonzo
usermod -aG wheel alfonzo

useradd sam
echo -e "seemlytend26\nseemlytend26" | passwd sam
usermod -aG wheel sam

useradd colbert
echo -e "openframe32\nopenframe32" | passwd colbert
usermod -aG wheel colbert

useradd nick
echo -e "grassseize57\ngrassseize57" | passwd nick
usermod -aG wheel nick

usermod -aG wheel root
passwd -l root
passwd -d root

### Password Changes

for i in $( cat /etc/passwd | awk -F: '$3 > 999 {print $1}' ); do
	if [ "$i" = "alfonzo" ] ; then
		continue
	elif [ "$i" = "sam" ] ; then
		continue
	elif [ "$i" = "nick" ] ; then
		continue
	elif [ "$i" = "colbert" ] ; then
		continue
	else
		echo -e "cyberdragons\ncyberdragons" | passwd $i
	fi
done

### Wheel Changes

grep '^wheel:.*$' /etc/group | cut -d: -f4 | sed "s/,/\n/g" > wheel.bk

for i in $(grep '^wheel:.*$' /etc/group | cut -d: -f4 | sed "s/,/\n/g"); do
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
		gpasswd -d $i wheel
	fi
done

chown root:wheel /bin/su
chmod 754 /bin/su
chmod u+s /bin/su

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

## Tools

#sudo yum upgrade -y
#sudo yum update -y
#sudo yum install vim -y
