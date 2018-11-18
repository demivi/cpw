# Config file for cpw

ENABLE_AUTO_UPDATE=true

# Set the number of days for an image to be detected as expired
# for auto update. Currently, can only take values between 2 and 
# 13 because of the docker image command output
export EXPIRATION=6

# This only controls directory creation by cpw. If you have a
# volume configured in your docker-compose.yml, the directory
# will be created even if this is set to false (it will however
# be own by root)
CREATE_VOLUME_DIRECTORY=true

export VOLUME_DIRECTORY=/home/$SUDO_USER/volume
