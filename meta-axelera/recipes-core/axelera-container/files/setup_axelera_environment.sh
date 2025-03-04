#!/bin/sh

VERSION="1.2.0-rc2"
ARCHIVE_NAME="axelera-sdk-ubuntu-2204-arm64.tar"
ARCHIVE_SHA256="7a4ca1492b836c8fa39ebdc5f39f1b3125b58d888c8c0049dccc75769eae1058"

if [ -f "$ARCHIVE_NAME" ]; then
	# Archive already present
	echo "Archive already downloaded. Checking SHA256..."
	echo "$ARCHIVE_SHA256  $ARCHIVE_NAME" | sha256sum -c || { echo "Wrong SHA256. Image is corrupted."; exit 1; }
else
	# Download the tar archive
	echo "Downloading archive..."
	return_code=$(curl --write-out %{http_code} -O "https://amarula-share.s3.eu-central-1.amazonaws.com/release/v$VERSION/$ARCHIVE_NAME")

	if [ "x$return_code" != "x200" ]; then
		echo "Failed to download."
		exit 1
	fi
fi

# Load the Docker image from the archive
echo "Loading Axelera Docker image..."
docker load < $ARCHIVE_NAME || { echo "Failed to load Docker image."; exit 1; }

echo "Setup complete."
