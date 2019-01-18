### Fedora iptables

#sudo iptables-save > iptables.dump
#sudo ip6tables-save > ip6tables.dump
#sudo iptables -F
#sudo ip6tables -F


sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# ip6tables -L
