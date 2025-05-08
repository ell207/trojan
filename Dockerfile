# Gunakan busybox sebagai base image
FROM busybox:glibc

# Tentukan versi v2ray-core yang ingin digunakan
ENV V2RAY_VERSION=5.12.0

# Buat direktori kerja
WORKDIR /etc/v2ray

# Unduh dan ekstrak v2ray-core
ADD https://github.com/v2fly/v2ray-core/releases/download/v${V2RAY_VERSION}/v2ray-linux-64.zip /tmp/v2ray.zip

# Ekstrak file zip (gunakan busybox unzip jika tersedia, atau gunakan image dengan unzip sebelumnya)
RUN mkdir -p /usr/bin/v2ray && \
    cd /usr/bin/v2ray && \
    unzip /tmp/v2ray.zip && \
    chmod +x /usr/bin/v2ray/v2ray /usr/bin/v2ray/v2ctl && \
    rm -rf /tmp/v2ray.zip

# Tambahkan file konfigurasi
COPY config.json /etc/v2ray/config.json
COPY cl.key /etc/v2ray/cl.key
COPY cl.pem /etc/v2ray/cl.pem

# Ekspose port Trojan WS
EXPOSE 4433

# Jalankan v2ray dengan config.json
ENTRYPOINT ["/usr/bin/v2ray/v2ray", "-config=/etc/v2ray/config.json"]
