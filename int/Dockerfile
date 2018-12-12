FROM base

RUN pacman -Syu --noconfirm && \
    pacman -S \
        aquatone \
        bettercap \
        crackmapexec \
        empire \
        enum4linux \
        impacket \
        iptables \
        metasploit \
        nmap \
        responder \
    --noconfirm --needed

# Empire specifics
RUN echo "dB9hiWTPX3VTN0ljCXpm" | empire-setup

RUN pacman -Scc --noconfirm
