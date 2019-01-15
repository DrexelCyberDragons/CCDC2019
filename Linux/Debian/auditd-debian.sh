### Debian auditd

sudo apt-get install auditd
sudo rm -rf /etc/audit/rules.d/audit.rules
sudo mv audit.rules /etc/audit/rules.d/
sudo systemctl start auditd
sudo systemctl enable auditd

### Setup stream
