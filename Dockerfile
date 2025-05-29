FROM ubuntu:22.04

LABEL maintainer="eldaa@example.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

# Install dependencies
RUN apt-get update && apt-get install -y \
    pcsx2 \
    x11vnc \
    xvfb \
    fluxbox \
    novnc \
    websockify \
    python3 \
    python3-pip \
    nginx \
    curl \
    sudo \
    inotify-tools \
    libgl1-mesa-glx \
    libgtk2.0-0 \
    && pip3 install flask \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create user
RUN useradd -ms /bin/bash ps2user
USER ps2user
WORKDIR /home/ps2user

# Create necessary directories
RUN mkdir -p /home/ps2user/games \
             /home/ps2user/uploads \
             /home/ps2user/.config/PCSX2/bios

# Copy files
COPY --chown=ps2user:ps2user start.sh /start.sh
COPY --chown=ps2user:ps2user upload_app.py /home/ps2user/upload_app.py
COPY nginx.conf /etc/nginx/nginx.conf

# Make script executable
RUN chmod +x /start.sh

# Expose single port
EXPOSE 6080

CMD ["/start.sh"]
