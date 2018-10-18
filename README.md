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
git clone https://github.com/demivi/cpw.git && \
cd cpw && \
makepkg -si
```

### Other distros

As root, clone the repository into /usr/lib/ and create a soft link to cpw.sh in /usr/bin; cpw.sh needs to be executable. You can remove the .git directory and the PKGBUILD file. Make sure only root has write access to every file.

Dependencies: docker, docker-compose, bash

## Usage

```
cpw {ls|run|rm|rerun|edit} <service>
```

This repository contains profile examples to give you something to start with. Edits of existing Dockerfiles or of the docker-compose.yml file can be done with the edit command. If you want to make more structural changes (removing or creating entirely new profiles), you will have to do so manually.
