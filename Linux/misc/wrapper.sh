user=root
host=10.0.1.173
me=192.168.1.190:8000

### cd /Users/Alfonzo/Desktop/CCDC
### tar -zcvf configs.tar.gz config
### tar -zcvf scripts.tar.gz apparmor-debian.sh configs-debian.sh modsecurity-debian.sh iptables-debian.sh
### python -m SimpleHTTPServer
### curl 192.168.1.190:8080/
## ssh -t rootuser@host 'wget myIP:port/CCDC2019/Linux/configs.tar.gz'

### Setting up

# Adding key to host
#ssh-copy-id ${user}@${host}

# Ask for user input for host os
#ssh -t ${user}@${host} 'cat /etc/os-release'
cat /etc/os-release
#ls /etc/ | grep "debian" | grep "redhat" | grep "*-release"
echo ' Please enter "debian" or "rhel" '
read os

# Moving configs over
#ssh -t ${user}@${host} "wget ${me}/CCDC2019/Linux/configs.tar.gz"
#wget ${me}/CCDC2019/Linux/configs.tar.gz
# Unzipping configs file
#ssh -t ${user}@${host} 'tar -xzvf configs.tar.gz'
#tar -xzvf configs.tar.gz
### Running scripts


if [ "$os" = "debian" ] ; then

  # Running Startup script
  #ssh -t ${user}@${host} "curl ${me}/CCDC2019/Linux/Debian/start-debian.sh | /bin/bash"
  #curl ${me}/CCDC2019/Linux/Debian/start-debian.sh | /bin/bash
  bash Debian/start-debian.sh
  # Running Reporting script
  #ssh -t ${user}@${host} "curl ${me}/CCDC2019/Linux/Debian/reporting-debian.sh | /bin/bash"
  #curl ${me}/CCDC2019/Linux/Debian/reporting-debian.sh | /bin/bash
  bash Debian/reporting-debian.sh
  # Moving other scripts over to the machine

  #wget ${me}/CCDC2019/Linux/Debian/scripts.tar.gz
  #tar -xzvf scripts.tar.gz

  #ssh -t ${user}@${host} "wget ${me}/CCDC2019/Linux/Debian/iptables-debian.sh"
  #ssh -t ${user}@${host} "wget ${me}/CCDC2019/Linux/Debian/configs-debian.sh"
  #ssh -t ${user}@${host} "wget ${me}/CCDC2019/Linux/Debian/modsecurity-debian.sh"
  #ssh -t ${user}@${host} "wget ${me}/CCDC2019/Linux/Debian/apparmor-debian.sh"

elif [ "$os" = "rhel" ] ; then

  # Running Startup script
  #ssh -t ${user}@${host} "curl ${me}/CCDC2019/Linux/RHEL/start-fedora.sh | /bin/bash"
  #curl ${me}/CCDC2019/Linux/RHEL/start-fedora.sh | /bin/bash
  bash RHEL/start-fedora.sh
  # Running Reporting script
  #ssh -t ${user}@${host} "curl ${me}/CCDC2019/Linux/RHEL/reporting-fedora.sh | /bin/bash"
  #curl ${me}/CCDC2019/Linux/RHEL/reporting-fedora.sh | /bin/bash
  bash RHEL/reporting-fedora.sh
  # Moving other scripts over to the machine

  #wget ${me}/CCDC2019/Linux/RHEL/scripts.tar.gz
  #tar -xzvf scripts.tar.gz

  #ssh -t ${user}@${host} "wget ${me}/CCDC2019/Linux/RHEL/iptables-fedora.sh"
  #ssh -t ${user}@${host} "wget ${me}/CCDC2019/Linux/RHEL/configs-fedora.sh"
  #ssh -t ${user}@${host} "wget ${me}/CCDC2019/Linux/RHEL/modsecurity-fedora.sh"
  ##ssh -t ${user}@${host} "wget ${me}/CCDC2019/Linux/RHEL/apparmor-fedora.sh"

  #wget
  #tar

fi
### Cleaning up

## Copying files back
#mkdir /Users/Alfonzo/Desktop/CCDC/CCDC2019/Linux/hostinfo/${host}
#scp ${user}@${host}:bash.bk /Users/Alfonzo/Desktop/CCDC/CCDC2019/Linux/hostinfo/${host}
#scp ${user}@${host}:sudo.bk /Users/Alfonzo/Desktop/CCDC/CCDC2019/Linux/hostinfo/${host}

## Removing files
#rm bash.bk
#rm sudo.bk
#ssh -t ${user}@${host} 'rm bash.bk'
#ssh -t ${user}@${host} 'rm version.txt'
#ssh -t ${user}@${host} 'rm sudo.bk'
