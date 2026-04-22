# ---------- Build stage ----------
FROM dart:stable AS builder

WORKDIR /app

# Copy manifest files first for layer caching
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get

# Copy source code
COPY bin/ bin/
COPY lib/ lib/

# Compile to native executable (no Dart SDK required at runtime)
RUN dart compile exe bin/server.dart -o bin/server_bin

# ---------- Runtime stage ----------
FROM debian:bookworm-slim

# fonttools provides the `ttx` command used for font score decoding
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-fonttools && \
    rm -rf /var/lib/apt/lists/*

# Install Isar native library system-wide
COPY --from=builder /app/bin/libisar.so /usr/local/lib/libisar.so
RUN ldconfig

# Install compiled server binary
COPY --from=builder /app/bin/server_bin /usr/local/bin/server
RUN chmod +x /usr/local/bin/server

# /data is the working directory at runtime:
#   - Isar database files (default.isar) are written here
#   - fonts/ subdirectory is used for temporary font processing
RUN mkdir -p /data/fonts

WORKDIR /data

EXPOSE 8081

CMD ["/usr/local/bin/server"]
