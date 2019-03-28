FROM archlinux/base

RUN useradd -m me && \
    mkdir /home/me/volume && \
    chown -R me. /home/me/volume

# Get a list of mirrors from archlinux.org, change country to fit your needs
RUN curl -s "https://www.archlinux.org/mirrorlist/?country=FR&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' > /etc/pacman.d/mirrorlist

RUN pacman -Syu --noconfirm && \
    pacman -S awk file git pkgfile tar vim wget which --noconfirm

# Setup Archstrike repository (https://archstrike.org/wiki/setup)
RUN echo $'\n[archstrike]\nServer = https://mirror.archstrike.org/$arch/$repo' >> /etc/pacman.conf && \
    sed -i 's_#\[multilib\]_[multilib]\nInclude = /etc/pacman.d/mirrorlist_' /etc/pacman.conf && \
    pacman -Syy && \
    pacman-key --init && \
    dirmngr < /dev/null && \
    wget https://archstrike.org/keyfile.asc && \
    pacman-key --add keyfile.asc && \
    pacman-key --lsign-key 9D5F1C051D146843CDA4858BDE64825E7CBC0D51 && \
    pacman -S archstrike-keyring --noconfirm && \
    pacman -S archstrike-mirrorlist --noconfirm && \
    sed -i 's_Server = https://mirror.archstrike.org/$arch/$repo_Include = /etc/pacman.d/archstrike-mirrorlist_' /etc/pacman.conf

# Setup BlackArch repository (https://blackarch.org/downloads.html)
RUN curl -O https://blackarch.org/strap.sh && \
    if [[ "$(sha1sum strap.sh | cut -d " " -f1)" = "9f770789df3b7803105e5fbc19212889674cd503" ]];then chmod +x strap.sh && ./strap.sh; fi

# Setup mcar repository
RUN sed -i '1i[mcar]\nSigLevel = PackageOptional\nServer = https://github.com/demivi/PKGBUILDs/releases/download/current/' /etc/pacman.conf

RUN pacman -Syy && \
    pkgfile -u

WORKDIR /home/me/volume
