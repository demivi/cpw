FROM base

# Order matters, since the hard constraint for Java requirements is
# on drozer, you can put it first in the list or install java explicitly
# if you don't want to install more than one version of Java
RUN pacman -Syu --noconfirm && \
    pacman -S \
        apksign \
        cfr \
        dex2jar \
        drozer \
        jdk7-openjdk \
        jre7-openjdk \
        jtool \
        p7zip \
        zipalign \
    --noconfirm --needed

RUN pacman -Scc --noconfirm
