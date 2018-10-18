FROM base

RUN pacman -Syu --noconfirm && \
    pacman -S \
        dirb \
        nikto \
        nmap \
        rsmangler \
        sqlmap \
    --noconfirm --needed

RUN pacman -Scc --noconfirm
