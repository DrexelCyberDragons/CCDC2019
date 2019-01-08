### iptables configuration

## Basic Rule structire
iptables -A INPUT -p tcp -m tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT

## Don't know what these do
#iptables -A INPUT -I lo -j ACCEPT #Doesn't work
iptables -A INPUT -j DROP

##Drop all packets that don't have rule
iptables -P INPUT DROP
