# Use the official Golang image as a parent image
FROM golang:1.21.5 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go modules manifests
COPY go.mod go.sum ./

# Download Go module dependencies
RUN go mod download

# Copy the local code to the container's workspace
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o ocwebsvc .
RUN chmod +x ocwebsvc

# Use a Docker multi-stage build to create a lean image
# Start from a smaller base image
FROM alpine:latest  

# Add CA certificates for HTTPS
RUN apk --no-cache add ca-certificates

# Set the working directory in the new container
WORKDIR /root/

# Copy the compiled binary from the builder stage
COPY --from=builder /app/ocwebsvc .

# Expose port 8080 to the outside world
EXPOSE 8080

# Run the executable
CMD ["./ocwebsvc"]

