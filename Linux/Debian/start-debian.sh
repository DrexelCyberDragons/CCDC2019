systemctl stop sshd
echo "net.ipv6.conf.all.disable_ipv6 = 1" >>  /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p
#rm -rf /etc/skel
#mv ../config/skel /etc/
useradd alfonzo -m -s /bin/bash -p '$6$rounds=4096$P65PHjtBjJ6el$r/GIe1OktX/1MpvEXFBazHH0vrN0TpN9xndOkKKd5vRRq4bXNSIT/3BwqLU/16WuE8raX1hq2VlbF8UulLiz31'
useradd sam -m -s /bin/bash -p '$6$rounds=4096$0ut.Q36mgUsrL$dymsL91iTnadEetup04SFXfnLWiOPuhAhxvqueZvLQ2.cCVRy/4kTusY6Cs23u0S.DBljKU1dQITZmtRN31HL1'
useradd matt -m -s /bin/bash -p '$6$rounds=4096$sLTudDG7wg1h$jxDHi1eJXk.z2cAeSRnNtJWvIGWfoJCPr3x0ReQhmCcf1i1eMZPw22g1cc1ybjjYXZmVD5IvwAvflA1TIlR8a0'

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
		usermod $i -p '$6$rounds=4096$arm0aqVICE$qZGlom8InzFtu5jOQMhQN/JTkcVxMNigNeZse5yPmxxoQRIH6hpHC.GpoEBbUB15FUi8xACK7jLM7UqKGutuJ/'
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
