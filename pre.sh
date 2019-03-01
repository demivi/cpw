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

# You can use this type of function to set custom cgroups for a
# given container. This example will remove restrictions on all USB
# devices for the container. This will allow you to use adb without
# starting containers in privileged mode for instance.
# You would still need to bind /dev/bus/usb as a volume though,
# which can be done by changing your docker-compose.yml (cpw edit).
set_cgroup () {
  major_number="$(ls -l /dev/bus/usb/001/001 | awk '{print $5}' | tr -d ',')"
  container_id="$(docker ps -qf "name=$1" --no-trunc)"
  echo "c $major_number:* rwm" > /sys/fs/cgroup/devices/docker/$container_id/devices.allow
}

# Wifi AP creation example for mobile application pentests
if [ "$1" = "mob" ]; then
#  AP_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12 ; echo '')
#  echo "AP password: $AP_PASSWORD"
#  create_ap --daemon <wifi_interface> <eth_interface> <ap_name> "$AP_PASSWORD" > /dev/null
#
#  # This part of the script will autoconfigure your AP on a plugged
#  # in phone. It requires adb on the host and the following app to
#  # be installed: https://github.com/steinwurf/adb-join-wifi
#  if [ -z "$(adb devices | grep 'device$')" ]; then
#    echo "Could not access device, you need to unlock it and allow debugging"
#    read -p "Press enter to continue" -n 1 -r
#    echo
#  fi
#
#  adb shell am start -n com.steinwurf.adbjoinwifi/.MainActivity -e ssid <ap_name> -e password_type WPA -e password "$AP_PASSWORD"
#  adb kill-server
#
#  iptables -I INPUT 2 -p tcp --dport 8080 -s 192.168.12.0/24 -j ACCEPT
#  iptables -t nat -A PREROUTING -p tcp -s 192.168.12.0/24 --dport 80 -j REDIRECT --to-port 8080
#  iptables -t nat -A PREROUTING -p tcp -s 192.168.12.0/24 --dport 443 -j REDIRECT --to-port 8080

  sleep 1 && set_cgroup "$1" &
fi

# Firewall conf example for internal network pentests
#if [ "$1" = "int" ]; then
#  iptables -I INPUT 2 -p tcp -m multiport --dports 21,25,53,80,88,110,139,143,389,443,445,587,1433,3141,4444 -j ACCEPT
#  iptables -I INPUT 2 -p udp -m multiport --dports 53,88,137,138,5353,5355 -j ACCEPT
#fi
