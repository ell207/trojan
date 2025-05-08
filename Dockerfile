
FROM alpine:latest


RUN apk update && apk add --no-cache \
    xfce4 \
    xfce4-terminal \
    tigervnc \
    && rm -rf /var/cache/apk/*


ENV VNCPASS=password
RUN mkdir -p ~/.vnc && \
    echo $VNCPASS | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

CMD ["x11vnc", "-forever", "-usepw", "-create"]
