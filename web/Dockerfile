FROM base

RUN pacman -Syu --noconfirm && \
    pacman -S \
        dirb \
        nikto \
        rsmangler \
    --noconfirm --needed

RUN pacman -Scc --noconfirm
