for i in $( cat /etc/passwd | awk -F: '$7 != /usr/sbin/nologin {print $1}' ); do
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
    usermod -s /usr/sbin/nologin $i
  fi
done
