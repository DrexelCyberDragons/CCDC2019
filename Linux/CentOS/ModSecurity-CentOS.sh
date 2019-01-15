### CentOS 7

## Add user to wheel group (sudoers)
#usermod -aG wheel user
## Removing root account
#sudo passwd -ld root

## Install ModSecurity & git if necessary
sudo yum install mod_security mod_security_crs -y
sudo yum install git -y

## Implement OWASP crs
cd /etc/httpd/modsecurity.d
sudo git clone https://github.com/SpiderLabs/owasp-modsecurity-crs
sudo mv owasp-modsecurity-crs/crs-setup.conf.example owasp-modsecurity-crs/crs-setup.conf

## Edit /etc/httpd/conf/httpd.conf
## Figure out how to do this automatically
echo "<IfModule security2_module>
                Include modsecurity.d/owasp-modsecurity-crs/crs-setup.conf
                Include modsecurity.d/owasp-modsecurity-crs/rules/*.conf
    </IfModule>" >> /etc/httpd/conf/httpd.conf

## In /etc/httpd/conf.d/00_mod_security.conf
## Change Include -> IncludeOptional

## Where is /etc/modsecurity for CentOS?

## Restart httpd
