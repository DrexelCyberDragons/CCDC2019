svcadm disable ssh

ipadm disable-addr -t net0/v6

useradd -s /bin/bash -m alfonzo
passwd -p '$6$rounds=4096$uPKYkEbKf$fBK7dMKA69b0w0GVeP5cCSHGt2mrTvCr.56RjOszff9pr4h8pCO2ETs8H1uMKcffkMuXhMuWyUGkwIxf0t6mb1' alfonzo
useradd -s /bin/bash -m sam
passwd -p '$6$rounds=4096$TshY2StJUgXf0nw$MSzrkWX59b/06cY.f46GijBr4yAwtQj1lp4krnrQe7A5uzCDRY8iB.m6UuqVziuSMj8gevH7Zl2vl2kIe0ocI0' sam
useradd -s /bin/bash -m colbert
passwd -p '$6$rounds=4096$o5SpX2soviy.jYU$buUMYjps9xquOf1CsfiTFxkQVB1LC1EyurGo2yClGB92UVPfHGtI0CJXK6E9gPeutfyEdqBneKPxRuS.i34ck1' colbert
useradd -s /bin/bash -m nick
passwd -p '$6$rounds=4096$8nH3H.duWKZneff$vNXLqSPXF0eUCXKM39LPdLna5kM/sl4JRnypm/WAx2OLeOlYc25ZO8OmHIHWRLyKD9ZOpQG3ytCydCgkujp5B/' nick

sed '/wheel ALL=(ALL) ALL$/s/^# //g' /etc/sudoers > /tmp/sudoers && cat /tmp/sudoers > /etc/sudoers && rm /tmp/sudoers

groupadd wheel

usermod -G +wheel alfonzo
usermod -G +wheel sam
usermod -G +wheel colbert
usermod -G +wheel nick

rm /etc/sudoers.d/svc-system-config-user

passwd -l root
passwd -d root

for i in $( passwd -as | grep PS | awk '{print $1}'); do
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
    usermod -G -sudo $i 2> /dev/null
    usermod -G -wheel $i 2> /dev/null
  fi
done

chown root:wheel /bin/su
chmod 754 /bin/su
chmod u+s /bin/su

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
    usermod -s /usr/sbin/nologin $i 2> /dev/null
  fi
done

svcadm enable ssh
