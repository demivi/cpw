# Config file for cpw

# This is a good place to define variables you want to be used
# by the docker-compose.yml file or the pre/post run scripts.

# This controls whether or not cpw will try to update whenever
# you run "cpw run <service>" if the image is older than the
# configured expiration delay.
ENABLE_AUTO_UPDATE=true

# Set the number of days for an image to be detected as expired
# for auto update. Currently, can only take values between 2 and 
# 13 because of the docker image command output format.
export EXPIRATION=6

# This is an example of a volume variable which can be used by
# docker-compose.yml and cpw pre/post docker-compose run scripts.
# You can make as many of these variables as you like.
export VOLUME_DIRECTORY=/home/$SUDO_USER/volume

# This is an array of the default arguments for the docker-compose
# run command. You can override those in the pre script if you want
# different arguments for some services.
RUN_ARGS=( "--service-ports" "--rm" )
