# This script runs before every docker-compose run initiated by cpw.

# The name of the docker-compose service cpw is about to run is 
# passed to this script as its first argument.

# Here are examples of what you can do with the pre run script.
# Some changes made here may need to be reflected in the post run
# script, like removal of firewall rules.

# Premptively creating your volume directories will allow you to
# set their permissions. If you let docker-compose create them they
# will be owned by root.
# For this example, the $VOLUME_DIRECTORY varialbe is defined in the 
# cpw configuration file (accessible via the "cpw conf" command)
if [ ! -d "$VOLUME_DIRECTORY" ]; then
  mkdir "$VOLUME_DIRECTORY"
  chown "$SUDO_USER" "$VOLUME_DIRECTORY"
fi

# Wifi AP creation example for mobile application pentests
#if [ "$1" = "mob" ]; then
#  create_ap --daemon <wifi_interface> <eth_interface> <ap_name> <ap_passphrase> > /dev/null
#
#  iptables -I INPUT 2 -p tcp --dport 8080 -s 192.168.12.0/24 -j ACCEPT
#  iptables -t nat -A PREROUTING -p tcp -s 192.168.12.0/24 --dport 80 -j REDIRECT --to-port 8080
#  iptables -t nat -A PREROUTING -p tcp -s 192.168.12.0/24 --dport 443 -j REDIRECT --to-port 8080
#fi

# Firewall conf example for internal network pentests
#if [ "$1" = "int" ]; then
#  iptables -I INPUT 2 -p tcp -m multiport --dports 21,25,53,80,88,110,139,143,389,443,445,587,1433,4444 -j ACCEPT
#  iptables -I INPUT 2 -p udp -m multiport --dports 53,88,137,138,5353,5355 -j ACCEPT
#fi
