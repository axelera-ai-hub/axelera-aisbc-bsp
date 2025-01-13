#!/bin/sh

SDK_PATH="voyager-sdk"
VERSION="1.1.0-rc5"

# Exit successfully if the voyager-sdk directory exists
if [ -d "$SDK_PATH" ]; then
    echo "$SDK_PATH already exists. Setup complete."
    exit 0
fi

# Download the tar archive
echo "Downloading archive..."
return_code=$(curl --write-out %{http_code} -O "https://amarula-share.s3.eu-central-1.amazonaws.com/release/v$VERSION/axelera-sdk-ubuntu-2204-arm64.tar")

if [ "x$return_code" != "x200" ]; then
    echo "Failed to download."
    exit 1
fi

# Load the Docker image from the archive
echo "Loading Axelera Docker image..."
docker load < axelera-sdk-ubuntu-2204-arm64.tar || { echo "Failed to load Docker image."; exit 1; }

# Create a Docker container from the image
echo "Creating Docker container from image..."
CONTAINER_ID=$(docker create axelera-sdk-ubuntu-2204-arm64:$VERSION) || { echo "Failed to create Docker container"; exit 1; }

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
