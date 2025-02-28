# Use Rust official image for building
FROM rust:1.75-alpine AS builder
WORKDIR /app

# Cache dependencies
RUN apk add --no-cache musl-dev
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo 'fn main() {}' > src/main.rs
RUN cargo build --release && rm -rf src

# Copy actual source code
COPY . .

# Build the final binary
RUN cargo build --release

RUN ls -lah .
RUN ls -lah /app/target/release
RUN cat src/main.rs
RUN sleep 10

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
