# This script runs after you stop containers ran with cpw.

# The name of the docker-compose service cpw just ran is passed 
# to this script as its first argument.

# Here are examples of what you can do with the post run script.
# Make sure cleanup tasks match what you did in the pre run script.

# Wifi AP cleanup example
#if [ "$1" = "mob" ]; then
#  create_ap --stop <wifi_interface>
#
#  iptables -D INPUT -p tcp --dport 8080 -s 192.168.12.0/24 -j ACCEPT
#  iptables -t nat -D PREROUTING -p tcp -s 192.168.12.0/24 --dport 80 -j REDIRECT --to-port 8080
#  iptables -t nat -D PREROUTING -p tcp -s 192.168.12.0/24 --dport 443 -j REDIRECT --to-port 8080
#fi

# Internal network pentest cleanup example
#if [ "$1" = "int" ]; then
#  iptables -D INPUT -p tcp -m multiport --dport 21,25,53,80,88,110,139,143,389,445,587,1433,4444 -j ACCEPT
#fi
