FROM base

RUN pacman -Syu --noconfirm && \
    pacman -S \
        dconf \
        gtk3 \
        jre11-openjdk \
        jre11-openjdk-headless \
        libxss \
        ttf-dejavu \
    --noconfirm --needed

# Doing this will not allow burp updates through cpw.
# You would need to rebuild by running 'cpw build burp'.
ADD https://portswigger.net/burp/releases/download?product=community&type=jar /opt/burp.jar

CMD java -jar /opt/burp.jar
