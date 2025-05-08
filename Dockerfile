
FROM alpine:latest


RUN apk update && apk add --no-cache \
    xfce4 \
    xfce4-terminal \
    tigervnc \
    tigervnc-server \
    && rm -rf /var/cache/apk/*


ENV VNCPASS=password
RUN mkdir -p ~/.vnc && \
    echo $VNCPASS | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

Expose port VNC
EXPOSE 5900

CMD ["x11vnc", "-forever", "-usepw", "-create"]
