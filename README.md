# cpw

A ComPose Wrapper for simple Docker image management.

I made this script mainly for the following reasons:
- Organize my pentest tools by engagement typologies
- Automate updates efficiently
- Simplify Docker usage and image/container management

I use it with Archstrike and BlackArch repositories, as well as my Arch Linux repository to allow full image update in one command:

https://github.com/demivi/PKGBUILDs

## Installing

### Arch Linux

#### Package

An Arch package is available at https://github.com/demivi/PKGBUILDs

#### Manual installation

If you don't want to use the above repository, copy and paste this into your terminal:
```
wget https://raw.githubusercontent.com/demivi/PKGBUILDs/master/cpw/PKGBUILD && \
makepkg -si
```

### Other distros

Clone the repository and make sure only root has write access to every file. Create a script in your $PATH that changes directory to where cpw.sh is located and executes it with the provided arguments.

Here is an example:

`/usr/bin/cpw`
```
#!/bin/sh
cd /usr/lib/cpw/
exec /usr/lib/cpw/cpw.sh "$@"
```

Dependencies: bash, docker, docker-compose

Optional: systemd, wget

## Usage

```
Usage: cpw {run|rm|rerun|edit|update|build|new|start|stop} <service>
   or: cpw {ls|edit|script}

    -ls: list services and check which of them have existing images
    -run: start a new service; will build or update images if necessary
    -rm: remove a service image
    -rerun: shortcut to rm then run
    -edit: edit existing service; give no argument to edit compose file
    -update: manually update service image
    -build: manually build service image
    -new: create new profile
    -start: start a container if '--rm' has been removed from run arguments
    -stop: stop a running container
    -script: edit cpw script
```

This repository contains profile examples as well as a cpw script to give you something to start with.

This tool provides an auto-update mechanism as well a scriptable interface to create service specific behaviors triggered by different events. Use 'cpw script' to modify these behaviors.
