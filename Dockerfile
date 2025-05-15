FROM alpine:latest

# Install curl dan unzip
RUN apk add --no-cache curl unzip

# Buat direktori kerja
WORKDIR /v2ray

# Unduh dan ekstrak V2Ray Core
RUN curl -L -o v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip && \
    unzip v2ray.zip && \
    chmod +x v2ray v2ctl && \
    rm v2ray.zip

# Salin konfigurasi dan sertifikat
COPY config.json /v2ray
COPY cl.pem /v2ray
COPY cl.key /v2ray

EXPOSE 4433

CMD ["./v2ray", "-config", "/v2ray/config.json"]
