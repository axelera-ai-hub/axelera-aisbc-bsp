#!/bin/sh

# This script is used to setup the Axelera environment.
# It downloads the Axelera SDK archive (Docker images) and the checksum file,
# and verifies the integrity of the archive using the checksum file.
# It then loads the Docker image from the archive.

if [ $# -ne 1 ]; then
  echo "Usage: $0 <SDK-version>"
  echo "Example: $0 1.2.5"
  exit 1
fi

VERSION=$1
VERSION_DIR="v${VERSION}"
ARCHIVE_NAME="axelera-sdk-ubuntu-2204-arm64.tar"
ARCHIVE_CHECKSUM="${ARCHIVE_NAME}.md5sum"
REMOTE_URL="https://amarula-share.s3.eu-central-1.amazonaws.com"

# Create version-specific directory
mkdir -p "$VERSION_DIR"
cd "$VERSION_DIR" || { echo "Failed to create/enter directory $VERSION_DIR"; exit 1; }

download_md5sum() {
  echo "Downloading checksum file..."
  return_code=$(curl --write-out %{http_code} -O "$REMOTE_URL/release/v$VERSION/$ARCHIVE_CHECKSUM")

  if [ "x$return_code" != "x200" ]; then
    echo "Warning: checksum file not found in remote location."
    rm -f "$ARCHIVE_CHECKSUM"
    exit 1
  fi
}

verify_md5sum() {
  if [ -f "$ARCHIVE_CHECKSUM" ]; then
    echo "Verifying MD5SUM..."
    if ! md5sum -c "$ARCHIVE_CHECKSUM"; then
      echo "Error: checksum verification failed. Archive may be corrupted."
      exit 1
    fi
  else
    echo "Checksum file not found at $ARCHIVE_CHECKSUM. Integrity check will be skipped."
  fi
}

if [ -f "$ARCHIVE_NAME" ]; then
  # Archive exists, check for MD5SUM
  echo "Using Docker image stored in directory: $(realpath $PWD)"
  if [ ! -f "$ARCHIVE_CHECKSUM" ]; then
    download_md5sum
  fi

  verify_md5sum
else
  echo "Downloading Docker image into directory: $(realpath $PWD)"
  return_code=$(curl --write-out %{http_code} -O "$REMOTE_URL/release/v$VERSION/$ARCHIVE_NAME")

  if [ "x$return_code" != "x200" ]; then
    echo "Failed to download archive."
    rm -f "$ARCHIVE_NAME"
    exit 1
  fi

  # Download and verify MD5SUM
  download_md5sum
  verify_md5sum
fi

# Load the Docker image from the archive
echo "Loading Docker image..."
docker load < $ARCHIVE_NAME || { echo "Failed to load Docker image."; exit 1; }

echo "Setup complete. Docker image loaded."
