FROM base

RUN pacman -Syu --noconfirm && \
    pacman -S \
        apksign \
        cfr \
        dex2jar \
        drozer \
        jtool \
        p7zip \
        smali \
        zipalign \
    --noconfirm --needed

RUN pacman -Scc --noconfirm
