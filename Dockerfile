FROM alpine:latest

# Install dependencies
RUN apk add --no-cache curl unzip

# Set workdir
WORKDIR /trojan

# Install Trojan-Go
RUN curl -L -o trojan-go.zip https://github.com/p4gefau1t/trojan-go/releases/latest/download/trojan-go-linux-amd64.zip \
    && unzip trojan-go.zip \
    && chmod +x trojan-go \
    && rm trojan-go.zip

# Copy config and SSL certs
COPY config.json /trojan/config.json
COPY cl.pem /trojan/cl.pem
COPY cl.key /trojan/cl.key

# Expose TLS port
EXPOSE 4433

# Run Trojan-Go
CMD ["./trojan/trojan-go", "-config", "/trojan/config.json"]
