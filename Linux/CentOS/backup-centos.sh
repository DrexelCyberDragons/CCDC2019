## CentOS 7 Backup

yum install rsync -y

# backup orangehrm
rsync -azrh /var/www/html /var/spool
cp /etc/my.cnf /var/spool
rsync -azrh /etc/ssh /var/spool
