#!/bin/bash

# Medical Chatbot - AWS EC2 One-Click Deployment Script
# This script installs Docker, Docker Compose, and runs the medical chatbot

set -e  # Exit on error

echo "=========================================="
echo "Medical Chatbot - EC2 Deployment Script"
echo "=========================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    print_error "This script is only for Linux systems (EC2)"
    exit 1
fi

# Get API keys from user
echo ""
print_info "Please provide your API keys (they will be stored in .env):"
echo ""

read -sp "Google Gemini API Key: " GOOGLE_API_KEY
echo ""
read -sp "Pinecone API Key: " PINECONE_API_KEY
echo ""

if [ -z "$GOOGLE_API_KEY" ] || [ -z "$PINECONE_API_KEY" ]; then
    print_error "API keys cannot be empty!"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_info "Installing Docker..."
    sudo yum update -y
    sudo yum install docker -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
    print_status "Docker installed successfully"
else
    print_status "Docker is already installed"
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_info "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    print_status "Docker Compose installed successfully"
else
    print_status "Docker Compose is already installed"
fi

# Clone or navigate to project
if [ ! -d ".git" ]; then
    print_info "Downloading Medical Chatbot..."
    # User should clone manually, so we assume they've done that
    print_error "Please clone the repository first!"
    exit 1
fi

# Create .env file
print_info "Creating .env file..."
cat > .env << EOF
GOOGLE_API_KEY=$GOOGLE_API_KEY
PINECONE_API_KEY=$PINECONE_API_KEY
EOF
print_status ".env file created"

# Build and run Docker container
print_info "Building Docker image..."
docker-compose up --build -d

echo ""
print_status "Medical Chatbot deployment complete!"
echo ""
echo "=========================================="
echo "Next Steps:"
echo "=========================================="
echo ""
echo "1. Wait for the container to start (30-60 seconds)"
echo "2. Access the chatbot at: http://$(hostname -I | awk '{print $1}'):8080"
echo ""
echo "Useful commands:"
echo "  View logs:        docker-compose logs -f"
echo "  Stop container:   docker-compose down"
echo "  Restart:          docker-compose restart"
echo "  Check status:     docker ps"
echo ""
echo "Security Group:"
echo "  - Allow inbound traffic on port 8080"
echo "  - Restrict source IPs as needed"
echo ""
