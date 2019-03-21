systemctl stop sshd
echo "net.ipv6.conf.all.disable_ipv6 = 1" >>  /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p
#rm -rf /etc/skel
#mv ../config/skel /etc/
useradd alfonzo -m -s /bin/bash
echo -e "cornermatter52\ncornermatter52" | passwd alfonzo
useradd sam -m -s /bin/bash
echo -e "annualresist00\nannualresist00" | passwd sam
useradd matt -m -s /bin/bash
echo -e "showersocial94\nshowersocial94" | passwd matt

usermod -aG sudo alfonzo
usermod -aG sudo sam
usermod -aG sudo matt
usermod -aG sudo root
passwd -ld root

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

for i in $(cat /etc/passwd | awk -F: '{print $1}'); do
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
