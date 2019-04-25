FROM base

# Order matters, since the hard constraint for Java requirements 
# is on drozer and smali, you can put them first in the list or 
# install java explicitly if you don't want to install more than 
# one version of Java.
RUN pacman -Syu --noconfirm && \
    pacman -S \
        apksign \
        cfr \
        dex2jar \
        drozer \
        jre8-openjdk \
        jtool \
        p7zip \
        ripgrep \
        smali \
        openssh \
        zipalign \
    --noconfirm --needed
