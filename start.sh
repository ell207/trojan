#!/bin/bash

# Start X virtual framebuffer
Xvfb :1 -screen 0 1280x720x16 &
fluxbox &

# Start VNC server
x11vnc -display :1 -forever -nopw -shared -quiet &

# Start noVNC web client
websockify --web=/usr/share/novnc/ --wrap-mode=ignore 5901 localhost:5900 &

# Start upload server
python3 /home/ps2user/upload_app.py &

# Start reverse proxy
sudo nginx

# Function to run latest ISO
run_latest_iso() {
  ISO=$(ls -t /home/ps2user/games/*.iso 2>/dev/null | head -n 1)
  if [ -n "$ISO" ]; then
    echo "Launching ISO: $ISO"
    pcsx2 "$ISO"
  else
    echo "Launching PCSX2 without ISO..."
    pcsx2
  fi
}

# Launch first ISO if available
run_latest_iso &

# Watch for new ISO uploads
while inotifywait -e create /home/ps2user/games; do
  pkill pcsx2
  sleep 2
  run_latest_iso &
done
