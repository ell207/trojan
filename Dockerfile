FROM alpine:latest

# Install curl dan unzip
RUN apk add --no-cache curl unzip v2ray

# Buat direktori kerja
WORKDIR /v2ray

# Salin konfigurasi dan sertifikat
COPY config.json /v2ray
COPY cl.pem /v2ray
COPY cl.key /v2ray

EXPOSE 4433

CMD ["v2ray", "run", "-config", "/v2ray/config.json"]
