systemctl stop sshd

useradd alfonzo -m -p '$6$rounds=4096$P65PHjtBjJ6el$r/GIe1OktX/1MpvEXFBazHH0vrN0TpN9xndOkKKd5vRRq4bXNSIT/3BwqLU/16WuE8raX1hq2VlbF8UulLiz31'
useradd sam -m -p '$6$rounds=4096$0ut.Q36mgUsrL$dymsL91iTnadEetup04SFXfnLWiOPuhAhxvqueZvLQ2.cCVRy/4kTusY6Cs23u0S.DBljKU1dQITZmtRN31HL1'
useradd matt -m -p '$6$rounds=4096$sLTudDG7wg1h$jxDHi1eJXk.z2cAeSRnNtJWvIGWfoJCPr3x0ReQhmCcf1i1eMZPw22g1cc1ybjjYXZmVD5IvwAvflA1TIlR8a0'

usermod -aG wheel alfonzo
usermod -aG wheel sam
usermod -aG wheel matt

usermod -aG wheel root
passwd -l root
passwd -d root

chattr -i /etc/sudoers
sed -i "s/# %wheel ALL=(ALL) ALL/ %wheel ALL=(ALL) ALL/" /etc/sudoers
sed -i "s/Defaults targetpw/#Defaults targetpw/" /etc/sudoers
sed -i "s/ALL   ALL=(ALL) ALL   # WARNING/#ALL   ALL=(ALL) ALL   # WARNING/" /etc/sudoers
chattr +i /etc/sudoers

for i in $( passwd -aS | grep ' P \| NP ' | cut -d' ' -f1 | sort | uniq ); do
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
		usermod $i -p '$6$rounds=4096$arm0aqVICE$qZGlom8InzFtu5jOQMhQN/JTkcVxMNigNeZse5yPmxxoQRIH6hpHC.GpoEBbUB15FUi8xACK7jLM7UqKGutuJ/'
	fi
done

grep '^wheel:.*$' /etc/group | cut -d: -f4 | sed "s/,/\n/g" > wheel.bk

for i in $(grep '^wheel:.*$' /etc/group | cut -d: -f4 | sed "s/,/\n/g"); do
	if [ "$i" = "alfonzo" ] ; then
		continue
	elif [ "$i" = "sam" ] ; then
		continue
	elif [ "$i" = "matt" ] ; then
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
