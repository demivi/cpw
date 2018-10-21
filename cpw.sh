#!/bin/bash

set -e

# Set the number of days for an image to be detected as expired
# Can only take values between 2 and 13
# Otherwise, the date detection code needs to be modified
export EXPIRATION=6

export VOLUME_DIRECTORY=/home/$SUDO_USER/volume

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

if [ $(systemctl is-active docker) = "inactive" ]; then
  echo "Docker is not running, attempting to start..."
  systemctl start docker

  if [ $(systemctl is-active docker) = "inactive" ]; then
    echo "Failed to start Docker, please start the Docker daemon manually"
    exit 1
  fi
fi

update_image () {
  if nc -zw2 google.com 443; then
    echo "Updating $1"
    docker run -tid --name update "$1"
    docker exec -ti update bash -c "pkgfile -u" &
    docker exec -ti update bash -c "pacman -Syu --noconfirm"
    docker commit update "$1"
    docker stop update
    docker rm update
  else
    echo "You do not seem to have Internet access, skipping update"
  fi
}

build_image () {
  if nc -zw2 google.com 443; then

    if [ "$2" = "pull" ]; then
      docker-compose build --pull "$1"
    else
      docker-compose build "$1"
    fi
  else
    echo "Can't build without internet access"
    exit 1
  fi
}

do_ls () {
  echo "Here are the existing services:"
  docker-compose config --services
  echo "Here are the images currently existing for these services:"
  services=$(docker-compose config --services)
  docker images | grep "^$services\s"
}

do_run () {
  if [ ! -d "$VOLUME_DIRECTORY" ]; then
    mkdir "$VOLUME_DIRECTORY"
    chown "$SUDO_USER" "$VOLUME_DIRECTORY"
  fi

  if [ -z $(docker-compose config --services | grep "$2") ]; then
    echo "This service does not exist"
    echo "Run one of these services or create a new one:"
    docker-compose config --services
    exit 1
  fi

  running=$(docker-compose ps "$2" | grep Up | awk '{print $1}')

  if [ -n "$running" ]; then
    echo "$running is running, spawning a shell..."
    exec docker exec -ti $running bash
  else
    image=$(docker images | grep "^$2\s" | awk '{print $1, $3, $4, $5, $7}')

    if [ -n "$image" ]; then
      echo "An image already exists for this service: "$image

      # If image is older than $EXPIRATION days, update it
      expired=$(echo "$image" | awk '$4=="months" || 
                                     $4=="weeks" || 
                                     ($3>=ENVIRON["EXPIRATION"]  && 
                                      $4=="days")')

      if [ -n "$expired" ]; then
        echo "$2 is more than $EXPIRATION days old, updating..."
        update_image "$2"
      fi

      exec docker-compose run --rm "$2"
    else
      echo "This service does not have an image yet, creating..."

      #Check if base exists, if it does update it, if not build it
      if $(docker images | grep -q "^base\s"); then
        update_image base
      else
        build_image base pull
      fi

      # Build service image once base has been created/updated
      if [ "$2" != "base" ]; then
        build_image "$2"
      fi

      exec docker-compose run --rm "$2"
    fi
  fi
}

do_rm () {
  if [ "$2" = "base" ]; then
    services=$(docker-compose config --services)

    if docker images | grep "^$services\s" | grep -v "^base\s"; then
      echo "WARNING: Those services still use base"

      read -p "Do you want to remove all of them? (y/N) " -n 1 -r
      echo

      if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose down --rmi all
        return 0
      else
        exit 1
      fi
    fi
  fi

  docker-compose rm "$2"
  docker rmi "$2"
}

do_rerun () {
  do_rm "$@"
  do_run "$@"
}

do_edit () {
  if [ "$2" ]; then
    "${EDITOR:-vim}" "$2"/Dockerfile

    read -p "Do you want to rebuild "$2" now? (y/N) " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      build_image "$2"

      if [ "$2" = "base" ]; then
        echo "#########################################################################"
        echo "NOTE: Use 'rerun <service>' to cascade changes to a service built on base"
        echo "#########################################################################"
      else
        exec docker-compose run --rm "$2"
      fi
    fi
  else
    "${EDITOR:-vim}" docker-compose.yml
  fi
}

case "$1" in
  ls)
    do_ls
    ;;

  run)
    do_run "$@"
    ;;

  rm)
    do_rm "$@"
    ;;

  rerun)
    do_rerun "$@"
    ;;

  edit)
    do_edit "$@"
    ;;

  *)
    echo "Usage: $0 {ls|run|rm|rerun|edit} <service>
    -ls: list services and check which of them have existing images
    -run: start a new service; will build or update images if necessary
    -rm: remove a service image
    -rerun: shortcut to rm then run
    -edit: edit existing service; give no argument to edit compose file"
    exit 1
esac
