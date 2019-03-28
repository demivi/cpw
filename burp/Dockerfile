FROM base

RUN pacman -Syu --noconfirm && \
    pacman -S \
        freetype2 \
        jre8-openjdk \
        jre8-openjdk-headless \
        libxrender \
        libxtst \
        ttf-dejavu \
    --noconfirm --needed

# Doing this will not allow burp updates through cpw.
# You would need to rebuild by running 'cpw build burp'.
ADD https://portswigger.net/burp/releases/download?product=community&type=jar burp.jar

CMD java -jar burp.jar
