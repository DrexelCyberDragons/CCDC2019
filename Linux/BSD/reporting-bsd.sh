#pkg install -F ntp


#pkg install -F py27-fail2ban
sysrc fail2ban_enable="YES"

#auditd

echo auditd_enable="YES" >> /etc/rc.conf
/etc/rc.d/auditd start
