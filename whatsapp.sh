#!/bin/bash

# **********************************************************
# *                                                        *
# *  Script to set up WhatsApp Proxy using Docker          *
# *  Author: Piokto                                        *
# *  GitHub: https://github.com/piokto                     *
# *  System: Debian 12                                     *
# *                                                        *
# **********************************************************

# Function to display status messages
function status_message {
    echo "============================"
    echo "$1"
    echo "============================"
}

# Update local packages
status_message "Updating local packages"
sudo apt update

# Install Docker
status_message "Installing Docker"
curl -fsSL https://test.docker.com -o test-docker.sh
sudo sh test-docker.sh
rm test-docker.sh

# Pull the WhatsApp Docker image
status_message "Pulling WhatsApp Docker image"
docker pull facebook/whatsapp_proxy:latest

# Clone the repository to the local server
status_message "Cloning repository to local server"
git clone https://github.com/WhatsApp/proxy.git

# Navigate to the repository directory
cd proxy

# Build the Docker image
status_message "Building Docker image"
docker build . -t whatsapp_proxy:1.0

# Run the proxy manually
status_message "Running WhatsApp Proxy"
docker run -it \
    -p 80:80 \
    -p 443:443 \
    -p 5222:5222 \
    -p 8080:8080 \
    -p 8443:8443 \
    -p 8222:8222 \
    -p 8199:8199 \
    -p 587:587 \
    -p 7777:7777 \
    whatsapp_proxy:1.0

status_message "WhatsApp Proxy setup complete!"
