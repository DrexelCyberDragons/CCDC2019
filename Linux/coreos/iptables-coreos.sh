iptables-save > old-iptables.bk

iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -p tcp --dport ssh -j ACCEPT
iptables -A INPUT -p tcp --dport http-alt -j ACCEPT

iptables -A INPUT -j DROP

iptables -I INPUT 5 -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7
iptables -I OUTPUT 5 -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

iptables-save > new-iptables.bk
iptables-save > /etc/iptables/rules.v4
