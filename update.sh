# This script controls how services are updated (auto and manual updates).

# The name of the docker-compose service cpw is about to update is 
# passed to this script as its first argument.
# You can thus have custom update commands for each of your services,
# disable autoupdate for some of them or only update if you meet some
# condition like having access to a private repository.

# Cleanup remaining container if the user hits CTRL+C during the update.
trap 'docker rm cpw_update' SIGINT

# This gets the current image CMD to reset it later when commiting.
current_cmd=$(docker inspect -f '{{.Config.Cmd}}' "$1" | sed 's/[][]//g')

# This is an example of how you could run a command in parallel to
# the update process. Note that this will be interrupted if it does
# not terminate before the main update, so only use this if you can
# afford the risk. This line is optionnal.
sleep 1 && docker exec -d cpw_update bash -c "pkgfile -u" &

# This is the update command. The image CMD is changed to allow
# update interruptions by hitting CTRL+C. Note that if you hit CTRL+C
# here, only the trap command above will be executed.
docker run -ti --name cpw_update "$1" bash -c "pacman -Syu --noconfirm"

# This commits the updated container and resets CMD
docker stop cpw_update
docker commit -c "CMD [\"$current_cmd\"]" cpw_update "$1"
docker rm cpw_update
