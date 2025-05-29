FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

RUN apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository ppa:gregory-hainaut/pcsx2.official.ppa -y \
    && apt-get update && apt-get install -y pcsx2 x11vnc xvfb fluxbox novnc websockify python3 python3-pip nginx curl sudo inotify-tools libgl1-mesa-glx libgtk2.0-0 libxcb-xinerama0 \
    && pip3 install flask \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash ps2user
USER ps2user
WORKDIR /home/ps2user

RUN mkdir -p /home/ps2user/games /home/ps2user/uploads /home/ps2user/.config/PCSX2/bios

COPY --chown=ps2user:ps2user start.sh /start.sh
COPY --chown=ps2user:ps2user upload_app.py /home/ps2user/upload_app.py
COPY nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /start.sh

EXPOSE 6080

CMD ["/start.sh"]
