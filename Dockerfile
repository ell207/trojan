FROM alpine:latest

RUN apk add --no-cache curl unzip

# Download V2Ray Core
RUN curl -L -o /v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip && \
    unzip /v2ray.zip -d /v2ray && \
    chmod +x /v2ray/v2ray /v2ray/v2ctl && \
    mv /v2ray /opt/v2ray

WORKDIR /opt/v2ray
COPY config.json .
COPY cl.pem .
COPY cl.key .

EXPOSE 443

CMD ["./v2ray", "-config", "config.json"]
