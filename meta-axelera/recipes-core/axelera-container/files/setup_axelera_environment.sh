#!/bin/sh

# Start the Docker service
echo "Starting Docker..."
systemctl start docker || { echo "Failed to start Docker."; exit 1; }

SDK_PATH="voyager-sdk"

# Exit successfully if the voyager-sdk directory exists
if [ -d "$SDK_PATH" ]; then
    echo "$SDK_PATH already exists. Setup complete."
    exit 0
fi

# Download the tar archive
echo "Downloading archive..."
curl -O "https://amarula-share.s3.eu-central-1.amazonaws.com/release/v1.1.0-rc2-0-g0ee2fdfd4/sdk-docker-image-build-ubuntu-22.04-arm64/axelera-sdk-ubuntu-2204-arm64.tar" || { echo "Failed to download."; exit 1; }

# Load the Docker image from the archive
echo "Loading Axelera Docker image..."
docker load < axelera-sdk-ubuntu-2204-arm64.tar || { echo "Failed to load Docker image."; exit 1; }

# Create a Docker container from the image
echo "Creating Docker container from image..."
CONTAINER_ID=$(docker create axelera-sdk-ubuntu-2204-arm64:1.1.0-rc2) || { echo "Failed to create Docker container"; exit 1; }

# Copy the voyager-sdk from the container
echo "Copying voyager-sdk from container $CONTAINER_ID..."
docker cp $CONTAINER_ID:/home/ubuntu/voyager-sdk . || { echo "Failed to copy voyager-sdk"; exit 1; }

# Remove the container
echo "Removing Docker container $CONTAINER_ID..."
docker rm $CONTAINER_ID || { echo "Failed to remove Docker container"; exit 1; }

# Change ownership of the voyager-sdk directory
echo "Changing ownership of voyager-sdk..."
chown -R 1000:1000 "voyager-sdk" || { echo "Failed to change ownership"; exit 1; }

echo "Setup complete."
