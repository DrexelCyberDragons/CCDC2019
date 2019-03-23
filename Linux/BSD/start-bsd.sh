#!/bin/sh

echo 'ip6addrctl_enable="NO"' >> /etc/rc.conf
echo 'ip6addrctl_policy="ipv4_prefer"' >> /etc/rc.conf
echo 'ipv6_activate_all_interfaces="NO"' >> /etc/rc.conf

service network restart
service sshd stop

# Add our users

pw user add alfonzo -G wheel -s /bin/sh -m
cp /root/.xinitrc /home/alfonzo/
pw user add sam -G wheel -s /bin/sh -m
cp /root/.xinitrc /home/sam/
pw user add matt -G wheel -s /bin/sh -m
cp /root/.xinitrc /home/matt/

# Manually setting passwords

echo '$6$rounds=4096$P65PHjtBjJ6el$r/GIe1OktX/1MpvEXFBazHH0vrN0TpN9xndOkKKd5vRRq4bXNSIT/3BwqLU/16WuE8raX1hq2VlbF8UulLiz31' | pw usermod alfonzo -H 0
echo '$6$rounds=4096$0ut.Q36mgUsrL$dymsL91iTnadEetup04SFXfnLWiOPuhAhxvqueZvLQ2.cCVRy/4kTusY6Cs23u0S.DBljKU1dQITZmtRN31HL1' |  pw usermod sam -H 0
echo '$6$rounds=4096$sLTudDG7wg1h$jxDHi1eJXk.z2cAeSRnNtJWvIGWfoJCPr3x0ReQhmCcf1i1eMZPw22g1cc1ybjjYXZmVD5IvwAvflA1TIlR8a0' | pw usermod matt -H 0

pw usermod root -h -
pw userdel toor

for i in $(cat /etc/master.passwd | awk -F: '$2 != "\*" {print $1}' | grep -v "^#"); do
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
    echo '$6$rounds=4096$gTSTsNoknGEAYMe$00xcP9cDrrIJ0jbaz3X3pmqS2h5SqW3uH/rAWJaQn6a8LQssdt7SsASY73gEgT5ToFdY4YE8D24xxPILvJjiR.' | pw usermod $i -H 0
  fi
done


for i in $(cat /etc/passwd | grep -v "^#" | awk -F: '{print $1}'); do
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
    pw groupmod wheel -d $i
    pw groupmod sudo -d $i
  fi
done

# remove shells

rm -f /usr/sbin/nologin
python2.7 -c "import base64; print base64.b64decode('IyEvYmluL3NoCmVjaG8gIlRoaXMgYWNjb3VudCBpcyBjdXJyZW50bHkgbm90IGF2YWlsYWJsZS4iCmV4aXQgMTsK')" > /usr/sbin/nologin
chmod 755 /usr/sbin/nologin

for i in $( cat /etc/passwd | grep -v "^#" | awk -F: '$7 != "/usr/sbin/nologin" {print $1}' ); do
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
    pw user mod $i -s /sbin/nologin
  fi
done

service sshd start
