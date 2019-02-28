FROM base

RUN pacman -Syu --noconfirm && \
    pacman -S \
        bettercap \
        crackmapexec \
        empire \
        enum4linux \
        impacket \
        metasploit \
        nmap \
        responder \
    --noconfirm --needed

# Empire specifics
RUN echo "dB9hiWTPX3VTN0ljCXpm" | empire-setup
