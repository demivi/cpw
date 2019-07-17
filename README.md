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

Clone the repository and make sure only root has write access to every file. Create a script in your $PATH that changes directory to where cpw is located and executes it with the provided arguments.

Here is an example:

`/usr/bin/cpw`
```
#!/bin/sh
cd /usr/lib/cpw/
exec /usr/lib/cpw/cpw "$@"
```

Dependencies: bash, docker, docker-compose

Optional: adb, create_ap, systemd, wget

## Usage

You will usually want to start by listing available profiles:
```
cpw ls
```

You can then start a profile with either of these commands:
```
cpw start <profile>
cpw run <profile>
```

- The first one will check for existing containers and will try to start the most recent one. If none is found it falls back to `cpw run`.
- The second command will start a new container for the profile regardless of existing ones.

For a complete list of cpw commands:
```
cpw -h
```

This repository contains profile examples to give you something to start with.

This tool provides an auto-update mechanism as well a scriptable interface to create service specific behaviors triggered by different events. Use `cpw script` to modify these behaviors.
