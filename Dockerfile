# Use Rust official image for building
FROM rust:1.85-alpine AS builder
WORKDIR /app

# Cache dependencies
RUN apk update && apk add --no-cache \
    musl-dev \
    build-base \
    openssl-dev \
    pkgconfig

ADD . . 
RUN ls -lah .

RUN cargo build --release

# Write files to log for potential debugging
RUN ls -lah /app/target/release && cat src/main.rs

# # Use a lightweight image for final container
# FROM alpine:3.21 
# WORKDIR /app

# Copy the built binary
# COPY --from=builder /app/target/release/alert_report_backend /app/alertreport

RUN cp /app/target/release/alert_report_backend /app/alertreport

ENV ROCKET_ADDRESS=0.0.0.0

# Expose port
EXPOSE 8000

# Run the server
ENTRYPOINT [ "/app/alertreport" ]
CMD [ "" ]
