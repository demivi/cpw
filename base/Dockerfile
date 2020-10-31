FROM archlinux/base

# Get a list of mirrors from archlinux.org, change country to fit your needs
RUN curl -s "https://www.archlinux.org/mirrorlist/?country=FR&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' > /etc/pacman.d/mirrorlist

RUN pacman -Syu --noconfirm && \
    pacman -S awk file git iproute2 pkgfile tar vim wget which --noconfirm

# Setup BlackArch repository (https://blackarch.org/downloads.html)
RUN curl -O https://blackarch.org/strap.sh && \
    if [[ "$(sha1sum strap.sh | cut -d " " -f1)" = "9c15f5d3d6f3f8ad63a6927ba78ed54f1a52176b" ]]; then chmod +x strap.sh && ./strap.sh; fi

# Setup mcar repository
RUN sed -i '1i[mcar]\nSigLevel = PackageOptional\nServer = https://github.com/demivi/PKGBUILDs/releases/download/current/' /etc/pacman.conf

RUN pacman -Syy && \
    pkgfile -u

RUN useradd -m me && \
    mkdir /volume && \
    chown -R me. /volume

WORKDIR /volume
