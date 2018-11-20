#!/bin/bash

set -e

source conf.sh

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

check_service_existence () {
  if [ -z $(docker-compose config --services | grep "$1") ]; then
    echo "This service does not exist"
    echo "Use one of these services or create a new one:"
    docker-compose config --services
    exit 1
  fi
}

update_image () {
  if $(docker ps -a | grep -q "cpw_update"); then
    docker rm cpw_update
  fi

  if nc -zw2 google.com 443; then
    echo "Updating $1"
    sleep 1 && docker exec -d cpw_update bash -c "pkgfile -u" &
    docker run -ti --name cpw_update "$1" bash -c "pacman -Syu --noconfirm"
    docker stop cpw_update
    docker commit --change='CMD ["/bin/bash"]' cpw_update "$1"
    docker rm cpw_update
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
  check_service_existence "$1"

  if [ ! -d "$VOLUME_DIRECTORY" ] && [ $CREATE_VOLUME_DIRECTORY = true ]; then
    mkdir "$VOLUME_DIRECTORY"
    chown "$SUDO_USER" "$VOLUME_DIRECTORY"
  fi

  running=$(docker-compose ps "$1" | grep Up | awk '{print $1}')

  if [ -n "$running" ]; then
    echo "$running is running, spawning a shell..."
    exec docker exec -ti $running bash
  else
    image=$(docker images | grep "^$1\s" | awk '{print $1, $3, $4, $5, $7}')

    if [ -n "$image" ]; then
      echo "An image already exists for this service: "$image

      # If image is older than $EXPIRATION days, update it
      expired=$(echo "$image" | awk '$4=="months" || 
                                     $4=="weeks" || 
                                     ($3>=ENVIRON["EXPIRATION"]  && 
                                      $4=="days")')

      if [ -n "$expired" ] && [ $ENABLE_AUTO_UPDATE = true ]; then
        echo "$1 is more than $EXPIRATION days old, updating..."
        update_image "$1"
      fi

      exec docker-compose run --rm "$1"
    else
      echo "This service does not have an image yet, creating..."

      #Check if base exists, if it does update it, if not build it
      if $(docker images | grep -q "^base\s"); then
        if [ $ENABLE_AUTO_UPDATE = true ]; then
          update_image base
        fi
      else
        build_image base pull
      fi

      # Build service image once base has been created/updated
      if [ "$1" != "base" ]; then
        build_image "$1"
      fi

      exec docker-compose run --rm "$1"
    fi
  fi
}

do_rm () {
  check_service_existence "$1"

  if $(docker ps -a | grep -q "cpw_update"); then
    docker rm cpw_update
  fi

  if [ "$1" = "base" ]; then
    services=$(docker-compose config --services)

    if docker images | grep "^$services\s" | grep -v "^base\s"; then
      echo "WARNING: Those services still use base"

      read -p "Do you want to remove all of them? (y/N) " -n 1 -r
      echo

      if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose down --rmi all
        docker rmi $(docker images -f "dangling=true" -q)
        return 0
      else
        exit 1
      fi
    fi
  fi

  docker rmi "$1"
}

do_edit () {
  if [ "$2" ]; then
    check_service_existence "$2"
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
    do_run "$2"
    ;;

  rm)
    do_rm "$2"
    ;;

  rerun)
    do_rm "$2"
    do_run "$2"
    ;;

  edit)
    do_edit "$1" "$2"
    ;;

  update)
    update_image "$2"
    ;;

  conf)
    "${EDITOR:-vim}" conf.sh
    ;;

  *)
    echo "
Usage: cpw {run|rm|rerun|edit|update} <service>
   or: cpw {ls|edit|conf}

    -ls: list services and check which of them have existing images
    -run: start a new service; will build or update images if necessary
    -rm: remove a service image
    -rerun: shortcut to rm then run
    -edit: edit existing service; give no argument to edit compose file
    -update: manually update service
    -conf: change cpw configuration
    "
    exit 1
esac
