#!/bin/bash

# Docker Android Build Script
# This script builds the Android APK using Docker with Java 21

set -e

echo "Building Android APK using Docker..."

# Build Docker image
echo "Building Docker image..."
docker build -t vegetipple-android-builder .

# Create output directory
mkdir -p build-output

# Run Docker container and copy both web and Android builds
echo "Running builds in Docker container..."
docker run --rm \
    -v "$(pwd)/build-output:/output" \
    vegetipple-android-builder \
    bash -c "
        # Copy web build
        cp -r www /output/ && \
        echo 'Web build copied to build-output/www/' && \
        
        # Build and copy Android APK
        cd android && chmod +x gradlew 2>/dev/null || true && \
        ./gradlew assembleDebug && \
        cp app/build/outputs/apk/debug/app-debug.apk /output/ && \
        echo 'APK built successfully and copied to build-output/app-debug.apk'
    "

echo "Build completed!"
echo "Web app available at: build-output/www/"
echo "Android APK available at: build-output/app-debug.apk"