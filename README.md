# cpw

A ComPose Wrapper for simple Docker image management.

I mainly made this script to manage my pentest tools by creating profiles for various engagement typologies and automating updates efficiently.

## Installing

### Arch Linux

#### Package

An Arch package is available at https://github.com/demivi/PKGBUILDs

#### Manual installation

If you don't want to use the repository, copy and paste this into your terminal:
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

Dependencies: docker, docker-compose, bash, netcat

## Usage

```
Usage: cpw {run|rm|rerun|edit|update} <service>
   or: cpw {ls|edit|conf}

    -ls: list services and check which of them have existing images
    -run: start a new service; will build or update images if necessary
    -rm: remove a service image
    -rerun: shortcut to rm then run
    -edit: edit existing service; give no argument to edit compose file
    -update: manually update service
    -conf: change cpw configuration

```

This repository contains profile examples to give you something to start with. Edits of existing Dockerfiles or of the docker-compose.yml file can be done with the edit command. If you want to make more structural changes (removing or creating entirely new profiles), you will have to do so manually.
