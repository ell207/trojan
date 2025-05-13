FROM alpine:latest

# Install curl, unzip dan bash (opsional)
RUN apk add --no-cache curl unzip

# Buat direktori kerja
WORKDIR /xray

# Unduh Xray-core
RUN curl -L -o xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip xray.zip && \
    chmod +x xray && \
    rm xray.zip

# Salin konfigurasi dan sertifikat TLS
COPY config.json /xray/config.json
COPY cl.key /xray/cl.key
COPY cl.pem /xray/cl.pem

# Buka port 4433
EXPOSE 4433

# Jalankan Xray
CMD ["./xray", "-config", "/xray/config.json"]
