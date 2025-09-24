#!/bin/bash

# Image Metadata Remover
# Coded by Pakistani White Hat Hacker Mr. Sabaz Ali Khan
# This script removes EXIF and other metadata from image files using ExifTool.
# Usage: ./remove_metadata.sh <image_file_or_directory>
# Requirements: ExifTool must be installed (e.g., sudo apt install exiftool on Debian-based systems)

# Function to display usage
usage() {
    echo "Usage: $0 <image_file_or_directory>"
    echo "Example: $0 *.jpg"
    echo "         $0 /path/to/images/"
    exit 1
}

# Check if argument is provided
if [ $# -eq 0 ]; then
    usage
fi

# Check if ExifTool is installed
if ! command -v exiftool &> /dev/null; then
    echo "Error: ExifTool is not installed. Please install it first."
    echo "On Ubuntu/Debian: sudo apt install exiftool"
    echo "On macOS: brew install exiftool"
    exit 1
fi

# Target path
TARGET="$1"

# Check if target is a file or directory
if [ -f "$TARGET" ]; then
    # Single file
    echo "Removing metadata from: $TARGET"
    exiftool -overwrite_original -all= "$TARGET"
    echo "Metadata removed successfully!"

elif [ -d "$TARGET" ]; then
    # Directory - process all common image files recursively
    echo "Removing metadata from images in: $TARGET"
    find "$TARGET" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.tiff" -o -iname "*.bmp" -o -iname "*.gif" \) -exec exiftool -overwrite_original -all= {} \;
    echo "Metadata removal completed for all images in the directory!"

else
    # Assume it's a pattern or single file that might not exist yet, but try processing
    echo "Processing files matching pattern: $TARGET"
    exiftool -overwrite_original -all= "$TARGET"
    if [ $? -eq 0 ]; then
        echo "Metadata removed successfully!"
    else
        echo "No files found or error occurred."
        usage
    fi
fi

# Clean up ExifTool's _original backups if desired (uncomment below)
# find . -name "*_original" -delete
