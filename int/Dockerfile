FROM base

RUN pacman -Syu --noconfirm && \
    pacman -S \
        bettercap \
        empire \
        enum4linux \
        iptables \
        metasploit \
        nmap \
        responder \
    --noconfirm --needed

# Empire specifics
RUN echo "dB9hiWTPX3VTN0ljCXpm" | empire-setup

RUN pacman -Scc --noconfirm
