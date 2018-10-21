FROM archlinux/base

RUN locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN useradd -m me && \
    mkdir /home/me/volume && \
    chown -R me. /home/me/volume

RUN pacman -Sy && \
    pacman -Rsn systemd --noconfirm && \
    pacman -Su --noconfirm && \
    pacman -S awk bash-completion file git pkgfile tar util-linux vim wget which --noconfirm

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
    sed -i 's_Server = https://mirror.archstrike.org/$arch/$repo_Include = /etc/pacman.d/archstrike-mirrorlist_' /etc/pacman.conf && \
    pacman -Syy

# Setup mcar repository
RUN sed -i '1i[mcar]\nSigLevel = PackageOptional\nServer = https://github.com/demivi/PKGBUILDs/releases/download/current/' /etc/pacman.conf && \
    pacman -Sy

RUN pkgfile -u

RUN pacman -Scc --noconfirm

WORKDIR /home/me/volume
