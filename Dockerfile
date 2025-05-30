FROM alpine:latest

# Install dependencies
RUN apk update && apk add --no-cache \
    curl unzip bash

# Install Xray-core
RUN curl -L https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o xray.zip \
    && unzip xray.zip -d /usr/local/bin \
    && rm xray.zip

# Buat direktori konfigurasi
RUN mkdir -p /etc/xray /etc/ssl/xray

# Salin file konfigurasi dan sertifikat
COPY config.json /etc/xray/config.json
COPY entrypoint.sh /entrypoint.sh
COPY cl.pem /etc/ssl/xray/cl.pem
COPY cl.key /etc/ssl/xray/cl.key

RUN chmod +x /entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
