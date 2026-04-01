FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
    tar \
    gzip \
    coreutils \
    procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Create archive directory
RUN mkdir -p /app/archives

COPY log-archive.sh /usr/local/bin/log-archive

COPY logger.sh /usr/local/bin/logger

RUN chmod +x /usr/local/bin/log-archive

RUN chmod +x /usr/local/bin/logger

# ENTRYPOINT [ "logger" ]

# CMD ["log-archive", "/logs"]

CMD ["/bin/bash"]