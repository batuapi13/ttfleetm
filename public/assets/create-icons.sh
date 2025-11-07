#!/bin/bash
# Create minimal valid PNG placeholder icons

# Base64 encoded 1x1 blue PNG
for size in 192 512; do
  echo "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==" | base64 -d > icon-${size}.png
  echo "Created placeholder icon-${size}.png"
done
