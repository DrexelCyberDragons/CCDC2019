systemctl stop sshd
#rm -rf /etc/skel
#mv ../config/skel /etc/
useradd alfonzo -m
echo -e "dustyspicy50\ndustyspicy50" | passwd alfonzo
usermod -aG wheel alfonzo

useradd sam -m
echo -e "seemlytend26\nseemlytend26" | passwd sam
usermod -aG wheel sam

useradd colbert -m
echo -e "openframe32\nopenframe32" | passwd colbert
usermod -aG wheel colbert

useradd nick -m
echo -e "grassseize57\ngrassseize57" | passwd nick
usermod -aG wheel nick

usermod -aG wheel root
#passwd -l root
#passwd -d root
echo -e "gentlerebel24\ngentlerebel24" | passwd root

### Password Changes

for i in $( passwd -aS | grep ' P \| NP ' | cut -d' ' -f1 | sort | uniq ); do
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
	elif [ "$i" = "scorebot" ] ; then
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

rm -f /usr/sbin/nologin
echo 'IyEvYmluL3NoCmVjaG8gIlRoaXMgYWNjb3VudCBpcyBjdXJyZW50bHkgbm90IGF2YWlsYWJsZS4iCmV4aXQgMTsK' | base64 -d > /usr/sbin/nologin
chmod 755 /usr/sbin/nologin

for i in $( cat /etc/passwd | cut -d: -f1 ); do
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
	elif [ "$i" = "scorebot" ] ; then
		continue
  else
    usermod -s /usr/sbin/nologin $i
  fi
done

systemctl start sshd
