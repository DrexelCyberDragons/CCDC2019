systemctl stop sshd

useradd -m -s /bin/bash alfonzo
echo -e "cornermatter52\ncornermatter52" | passwd alfonzo
useradd -m -s /bin/bash sam
echo -e "annualresist00\nannualresist00" | passwd sam
useradd -m -s /bin/bash matt
echo -e "showersocial94\nshowersocial94" | passwd matt

#pacman -S sudo
#groupadd sudo
#sudo sed -i "s/# %sudo ALL=(ALL) ALL/%sudo ALL=(ALL) ALL/" /etc/sudoers

for i in $( passwd -aS | grep ' P \| NP ' | awk '{print $1}' ); do
	if [ "$i" = "alfonzo" ] ; then
		continue
	elif [ "$i" = "sam" ] ; then
		continue
	elif [ "$i" = "matt" ] ; then
		continue
	elif [ "$i" = "scorebot" ] ; then
		continue
	elif [ "$i" = "root" ] ; then
		continue
	else
		echo -e "cyberdragons\ncyberdragons" | passwd $i
	fi
done

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

for i in $(grep '^sudo:.*$' /etc/group | cut -d: -f4 | sed "s/,/\n/g"); do
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

#sudo chown root:sudo /bin/su
#sudo chmod 754 /bin/su
#sudo chmod u+s /bin/su

rm -f /usr/sbin/nologin
echo 'IyEvYmluL3NoCmVjaG8gIlRoaXMgYWNjb3VudCBpcyBjdXJyZW50bHkgbm90IGF2YWlsYWJsZS4iCmV4aXQgMTsK' | base64 -d > /usr/sbin/nologin
chmod 755 /usr/sbin/nologin

for i in $( cat /etc/passwd | cut -d: -f1 ); do
  if [ "$i" = "alfonzo" ] ; then
    continue
  elif [ "$i" = "sam" ] ; then
    continue
  elif [ "$i" = "matt" ] ; then
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
