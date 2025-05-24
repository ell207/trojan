# Gunakan image base ringan
FROM alpine:latest

# Set direktori kerja
WORKDIR /trojan

# Install dependensi
RUN apk add --no-cache curl unzip ca-certificates

# Unduh dan ekstrak Trojan-Go
RUN curl -L -o trojan-go.zip https://github.com/p4gefau1t/trojan-go/releases/latest/download/trojan-go-linux-amd64.zip \
    && unzip trojan-go.zip \
    && rm trojan-go.zip \
    && chmod +x trojan-go \
    && cp trojan-go /bin/

# Salin file konfigurasi dan sertifikat TLS jika diperlukan (nanti bisa di-mount via volume)
# Contoh: config.json, fullchain.crt, private.key
COPY config.json .
COPY cl.pem .
COPY cl.key .

# Buka port Trojan-Go (default: 443)
EXPOSE 4433

# Jalankan trojan-go dengan config (pastikan config.json ada di /trojan)
CMD ["trojan-go", "-config", "config.json"]
