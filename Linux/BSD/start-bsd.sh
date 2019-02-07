
# /usr/share/skel
# weird rc files

# packages in /var/cache/pkg

# Add our users

pw user add alfonzo -G wheel -s /bin/sh
pw user add sam -G wheel -s /bin/sh
pw user add nick -G wheel -s /bin/sh
pw user add colbert -G wheel -s /bin/sh

# Manually setting passwords

passwd alfonzo
passwd sam
passwd nick
passwd colbert

# Locking unused users

for i in $( cat /etc/passwd | awk -F: '$3 > 999 {print $1}' ); do
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
		pw lock $i
	fi
done

# Wheel sudo rights

sed -i "" "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/" /usr/local/etc/sudoers

grep '^wheel:.*$' /etc/group | cut -d: -f4 | tr , '\n' > wheel.bk

for i in $(grep '^wheel:.*$' /etc/group | cut -d: -f4 | tr , '\n'; do
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
		pw group mod wheel -d $i
	fi
done

# remove shells

cat /etc/passwd | awk -F: '$7 != "/sbin/nologin" {print $1}' > bash.bk

for i in $( cat /etc/passwd | awk -F: '$7 != "/sbin/nologin" {print $1}' ); do
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
