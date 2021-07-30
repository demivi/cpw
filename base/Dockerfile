FROM archlinux

# Get a list of mirrors from archlinux.org, change country to fit your needs
RUN curl -s "https://archlinux.org/mirrorlist/?country=FR&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' > /etc/pacman.d/mirrorlist

RUN pacman -Syu --noconfirm && \
    pacman -S awk file git iproute2 pkgfile tar vim wget which --noconfirm

# Setup BlackArch repository (https://blackarch.org/downloads.html)
RUN curl -O https://blackarch.org/strap.sh && \
    if [[ "$(sha1sum strap.sh | cut -d " " -f1)" = "edf8a85057ea49dce21eea429eb270535f3c5f9a" ]]; then chmod +x strap.sh && ./strap.sh; else echo 'Error: Wrong BlackArch SHA1' && exit 1; fi

# Setup mcar repository
RUN sed -i '1i[mcar]\nSigLevel = PackageOptional\nServer = https://github.com/demivi/PKGBUILDs/releases/download/current/' /etc/pacman.conf

RUN pacman -Syy && \
    pkgfile -u

RUN useradd -m me && \
    mkdir /volume && \
    chown -R me. /volume

WORKDIR /volume
