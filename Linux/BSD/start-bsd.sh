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
pw user add nick -G wheel -s /bin/sh -m
cp /root/.xinitrc /home/nick/
pw user add colbert -G wheel -s /bin/sh -m
cp /root/.xinitrc /home/colbert/

# Manually setting passwords

echo '$6$rounds=4096$uPKYkEbKf$fBK7dMKA69b0w0GVeP5cCSHGt2mrTvCr.56RjOszff9pr4h8pCO2ETs8H1uMKcffkMuXhMuWyUGkwIxf0t6mb1' | pw usermod alfonzo -H 0
echo '$6$rounds=4096$TshY2StJUgXf0nw$MSzrkWX59b/06cY.f46GijBr4yAwtQj1lp4krnrQe7A5uzCDRY8iB.m6UuqVziuSMj8gevH7Zl2vl2kIe0ocI0' |  pw usermod sam -H 0
echo '$6$rounds=4096$o5SpX2soviy.jYU$buUMYjps9xquOf1CsfiTFxkQVB1LC1EyurGo2yClGB92UVPfHGtI0CJXK6E9gPeutfyEdqBneKPxRuS.i34ck1' | pw usermod colbert -H 0
echo '$6$rounds=4096$8nH3H.duWKZneff$vNXLqSPXF0eUCXKM39LPdLna5kM/sl4JRnypm/WAx2OLeOlYc25ZO8OmHIHWRLyKD9ZOpQG3ytCydCgkujp5B/' | pw usermod nick -H 0

pw usermod root -h -
pw userdel toor

for i in $(cat /etc/master.passwd | awk -F: '$2 != "\*" {print $1}' | grep -v "^#"); do
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
    passwd -p '$6$rounds=4096$gTSTsNoknGEAYMe$00xcP9cDrrIJ0jbaz3X3pmqS2h5SqW3uH/rAWJaQn6a8LQssdt7SsASY73gEgT5ToFdY4YE8D24xxPILvJjiR.' $i
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
    pw groupmod wheel -d $i
    pw groupmod sudo -d $i
  fi
done

# remove shells

rm -f /usr/sbin/nologin
python2.7 -c "import base64; print base64.b64decode('IyEvYmluL3NoCmVjaG8gIlRoaXMgYWNjb3VudCBpcyBjdXJyZW50bHkgbm90IGF2YWlsYWJsZS4iCmV4aXQgMTsK')" > /usr/sbin/nologin
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
    pw user mod $i -s /sbin/nologin
  fi
done

service sshd start
