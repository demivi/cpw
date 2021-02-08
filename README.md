# cpw

A ComPose Wrapper for simple Docker image management through the command line.

This tools could help you if you often find yourself tired of micro-managing a bunch of Docker images/containers on your machine.

This is **not** a production tool you would have on a server to run a bunch of applications, it's not meant to replace Swarm or Kubernetes.

It's more about quick and dirty Docker manipulations. It basically takes away the native Docker commands clutter by leaning on Docker Compose and adding some convenient features on top of that.

Stuff cpw can do:
- Reduce building, running and updating images to one command: `cpw run <profile>`
- Fully customizable via scripting, for example:
    - For profile A, fetch a file on a private repository before building, and prompt for a password.
    - For profile B, try to update every time I run a container, as opposed to the monthly update configured for the other profiles.
    - For profile C, cleanup all files older than a month in the logs volume every time I use the profile.
    - For profile D, setup some specific firewall rules on my host at startup, restore them when I stop the container.
    - For profile E, setup a wifi access point and redirect all its traffic to a local proxy for HTTP analysis.
    - For profile F, modify the container Cgroups after startup to allow access to USB ports without relying on --privileged.
    - For profile G, bind mount its container network namespace after startup so it can be accessed by `ip netns`.
    - For profile H, dynamically switch network modes of profiles A to E, to bind them to H's network namespace (useful if profile H runs a VPN for example).
- Allows system updates of an image without rebuilding the whole image (`cpw update <profile>`).
- Allows recursive dependency on local images, for example:
    - `ext` is a child of `web`, which is a child of `base`, which is a child of the official Arch Linux image (the only remote one in the chain).
    - Doing `cpw run ext` will check/build/update every image in the chain and start a container for `ext`.
    - This makes it easier to split dependencies amongst different profiles and thus reducing rebuild and update times for individual profiles.

My need for this tool arose when I started to use Docker to manage my pentest tools by engagement typologies. The idea was to have a clean, updated and isolated environment on each new engagement. I ended up using it for a bunch more stuff, like running multiple VPNs at the same time with separated network namespaces, quick prototyping with images from the Docker hub, a bit of dev work, running postgres, updating tools on my Arch Linux repository...

The tool is packaged with example profiles based on Arch Linux to get you started, but you can ditch everything and create new profiles from scratch.

Another point was to update every pentest tool with just a system update, so I use cpw with my own Arch Linux repository for when I can't find some packages elsewhere or if I need modified/dev versions of some packages :

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

You can also use the install script as described bellow.

### Other distros

#### Install script

You can use the install script which will copy cpw files to the appropriate directories.

It will also act as an update script. So if you want to update, download a new release of cpw (or pull from the repository) and rerun the install script.

#### Manual installation

Clone the repository and make sure only root has write access to every file. Create a script in your $PATH that changes directory to where cpw is located and executes it with the provided arguments.

Here is an example:

`/usr/bin/cpw`
```
#!/bin/sh
cd /usr/lib/cpw/
exec /usr/lib/cpw/cpw "$@"
```

Dependencies: bash, docker, docker-compose, sudo

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

The `cpw run` command does the following things:
- Build the image and its parents if they do not exist.
- Update the image and its parents if they are older than the configured time limit.
- Rebuild the image and its parents if they are older than the configured time limit.
- Run the `prerun` hook.
- Start the container with `docker-compose run`.
- Once the `docker-compose run` returns, run the `postrun` hook.

The time limits parameters and hooks code can be viewed/modified via `cpw script`. This file is where you can do all the custom scripting. It contains the following hooks:
- init: The first thing that runs every time a cpw command is executed.
- update: The code that runs when cpw updates an image.
- build: The code that runs when cpw builds an image.
- prerun: Runs every time before `docker-compose run` (triggered by `cpw run <profile>`).
- postrun: Runs every time the `docker-compose run` command returns.
- start: Code for the `cpw start <profile>` command (equivalent to `docker start`).
- exec: Code for the `cpw exec <profile>` command (equivalent to `docker exec`).
- commit: Code for the `cpw commit <profile>` command (equivalent to `docker commit`).
- stop: Code for the `cpw stop <profile>` command (equivalent to `docker stop`).
- exit: Runs every time the cpw process ends without being interrupted.

The `init` hook contains cpw configuration. I would recommend at least reading this part of `cpw script`. The most important parameters are `UPDATE_DAYS` and `REBUILD_DAYS`. Basically, every time you run `cpw run <profile>`, the date of the corresponding image is checked against those parameters. The `UPDATE_DAYS` should be the lower one, so the first to trigger: the idea is to only do a system update on the image which shouldn't take too much time. When your image gets older, the `REBUILD_DAYS` limit will eventually be reached too and will trigger a full rebuild of the image. You can change/disable/enable this behavior on a per profile basis (by adding an if statement in the `init` section).

If you want to see or edit the list of profiles and their parameters (docker-compose.yml), use this command:
```
cpw edit
```

If you want to edit a specific profile (Dockerfile):
```
cpw edit <profile>
```

For a complete list of cpw commands:
```
cpw -h
```
