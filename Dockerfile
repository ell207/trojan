FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    qemu-system-x86 \
    adb \
    scrcpy \
    wget curl \
    unzip \
    x11vnc \
    xvfb \
    openbox \
    net-tools \
    iputils-ping \
    && apt-get clean

# Add user
RUN useradd -m android
USER android
WORKDIR /home/android

# Download Android-x86 ISO (Android 9.0)
RUN mkdir iso && cd iso && \
    wget -O android-x86.iso https://archive.org/download/android-x86_64-9.0-r2_202201/android-x86_64-9.0-r2.iso

# Startup script: Launch QEMU and enable ADB TCP
RUN echo '#!/bin/bash\n\
Xvfb :1 -screen 0 1280x720x24 &\n\
export DISPLAY=:1\n\
openbox &\n\
# Launch Android-x86 in QEMU with hostfwd for adb\n\
qemu-system-x86_64 \\\n\
  -m 5G \\\n\
  -smp 5 \\\n\
  -cdrom /home/android/iso/android-x86.iso \\\n\
  -boot d \\\n\
  -net nic -net user,hostfwd=tcp::5555-:5555 \\\n\
  -vga virtio \\\n\
  -display sdl &\n\
# Wait for Android to boot\n\
sleep 60\n\
# Attempt to connect ADB and enable TCP/IP mode\n\
adb connect 127.0.0.1:5555\n\
adb -s 127.0.0.1:5555 shell \"setprop service.adb.tcp.port 5555; stop adbd; start adbd\"\n\
sleep 5\n\
adb connect 127.0.0.1:5555\n\
# Launch scrcpy\n\
scrcpy --serial 127.0.0.1:5555 --bit-rate 8M --max-size 1024\n' > /home/android/start.sh && chmod +x /home/android/start.sh

ENTRYPOINT ["/home/android/start.sh"]
