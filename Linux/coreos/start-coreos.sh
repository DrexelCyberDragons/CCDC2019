systemctl stop sshd
#rm -rf /etc/skel
#mv ../config/skel /etc/
touch /etc/sysctl.d/10-disable_ipv6.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" >>  /etc/sysctl.d/10-disable_ipv6.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.d/10-disable_ipv6.conf
systemctl restart systemd-sysctl.service

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

for i in $( passwd -aS | grep ' P \| NP ' | awk '{print $1}' | sort | uniq ); do
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
		gpasswd -d $i sudo
	fi
done

### No login

rm -f /usr/sbin/nologin
echo 'IyEvYmluL3NoCmVjaG8gIlRoaXMgYWNjb3VudCBpcyBjdXJyZW50bHkgbm90IGF2YWlsYWJsZS4iCmV4aXQgMTsK' | base64 -d > /usr/sbin/nologin
chmod 755 /usr/sbin/nologin

for i in $( cat /etc/passwd | cut -d: -f7 ); do
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
