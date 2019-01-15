### Fedora auditd

sudo su
sudo yum install audit -y
sudo rm -rf /etc/audit/rules.d/audit.rules
sudo mv audit.rules /etc/audit/rules.d/
sudo systemctl start auditd
sudo systemctl enable auditd
exit

### Setup stream
