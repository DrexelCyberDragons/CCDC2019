### cd /Users/Alfonzo/Desktop/CCDC
### tar -zcvf configs.tar.gz config
### python -m SimpleHTTPServer
### curl 192.168.1.190:8080/

## ssh -t rootuser@host 'wget myIP:port/CCDC2019/Linux/configs.tar.gz'
# Moving configs over
ssh -t root@10.0.1.172 'wget 192.168.1.190:8000/CCDC2019/Linux/configs.tar.gz'
# Unzipping configs file
ssh -t root@10.0.1.172 'tar -xzvf configs.tar.gz'

# Running Startup script
ssh -t root@10.0.1.172 'curl 192.168.1.190:8000/CCDC2019/Linux/Debian/start-debian.sh | /bin/bash'

# Running Reporting script
ssh -t root@10.0.1.172 'curl 192.168.1.190:8000/CCDC2019/Linux/Debian/reporting-debian.sh | /bin/bash'
