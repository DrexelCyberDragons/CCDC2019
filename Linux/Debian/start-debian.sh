systemctl stop sshd
echo "net.ipv6.conf.all.disable_ipv6 = 1" >>  /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p
#rm -rf /etc/skel
#mv ../config/skel /etc/
useradd alfonzo -m -s /bin/bash
echo -e "dustyspicy50\ndustyspicy50" | passwd alfonzo
useradd sam -m -s /bin/bash
echo -e "seemlytend26\nseemlytend26" | passwd sam
useradd colbert -m -s /bin/bash
echo -e "openframe32\nopenframe32" | passwd colbert
useradd nick -m -s /bin/bash
echo -e "grassseize57\ngrassseize57" | passwd nick
usermod -aG sudo alfonzo
usermod -aG sudo sam
usermod -aG sudo colbert
usermod -aG sudo nick
usermod -aG sudo root
passwd -ld root

for i in $( passwd -aS | grep ' P \| NP ' | awk '{print $1}' ); do
	if [ "$i" = "alfonzo" ] ; then
		continue
	elif [ "$i" = "sam" ] ; then
		continue
	elif [ "$i" = "nick" ] ; then
		continue
	elif [ "$i" = "colbert" ] ; then
		continue
	elif [ "$i" = "scorebot" ] ; then
		continue
	elif [ "$i" = "root" ] ; then
		continue
	else
		echo -e "cyberdragons\ncyberdragons" | passwd $i
	fi
done

for i in $(cat /etc/passwd | awk -F: '{print $1}'); do
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
		deluser $i sudo
		deluser $i admin
	fi
done

sudo chown root:sudo /bin/su
sudo chmod 754 /bin/su
sudo chmod u+s /bin/su

rm -f /usr/sbin/nologin
echo 'IyEvYmluL3NoCmVjaG8gIlRoaXMgYWNjb3VudCBpcyBjdXJyZW50bHkgbm90IGF2YWlsYWJsZS4iCmV4aXQgMTsK' | base64 -d > /usr/sbin/nologin
chmod 755 /usr/sbin/nologin

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
	elif [ "$i" = "scorebot" ] ; then
		continue
  else
    usermod -s /usr/sbin/nologin $i
  fi
done

systemctl start sshd
