#!/usr/bin/python

import os
import random

file_name = "/tmp/tcpdump" + str(random.randrange(100))

# Ask for password no so don't have to ask on next command
os.system("sudo echo")
os.system("mkfifo " + file_name)
os.system("sudo wireshark -k -i {} 2>/dev/null &".format(file_name))

user = "user"
ip = raw_input("IP Address: ").strip()
interface = raw_input("Network Interface: ").strip()
os.system('ssh -v -o "IdentitiesOnly=yes" {}@{} "echo cyberdragons | sudo -S tcpdump -s 0 -U -n -w - -i {} not port 22" > {}'.format(user, ip, interface, file_name))
