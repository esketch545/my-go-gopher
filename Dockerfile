# Use the official Go image as the builder
FROM golang:1.24.1 AS builder

# Set the working directory
WORKDIR /app

# Copy and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the application source code
COPY . .

# Build the Go binary
RUN go build -o main .

# Use a minimal base image for the final container
FROM gcr.io/distroless/base-debian12

# Set the working directory
WORKDIR /

# Copy the built binary from the builder stage
COPY --from=builder /app/main .

# Expose the necessary port
EXPOSE 8080

# Run the binary
CMD ["./main"]
