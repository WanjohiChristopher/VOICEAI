#!/bin/bash

# ============================================
# Voice AI Hub - EC2 Deployment Script
# Domain: voiceai.wanjohichristopher.com
# ============================================

set -e  # Exit on any error

echo "🎙️ Voice AI Hub - Deployment Script"
echo "===================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Step 1: Update system
echo -e "${CYAN}[1/6] Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

# Step 2: Install Nginx
echo -e "${CYAN}[2/6] Installing Nginx...${NC}"
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx

# Step 3: Create website directory
echo -e "${CYAN}[3/6] Setting up website directory...${NC}"
sudo mkdir -p /var/www/voiceai
sudo chown -R $USER:$USER /var/www/voiceai

# Step 4: Copy website files
echo -e "${CYAN}[4/6] Copying website files...${NC}"
cp index.html /var/www/voiceai/
cp voice.gif /var/www/voiceai/
cp -r diagrams /var/www/voiceai/
echo -e "${GREEN}✓ Files copied to /var/www/voiceai/${NC}"

# Step 5: Configure Nginx
echo -e "${CYAN}[5/6] Configuring Nginx...${NC}"
sudo cp voiceai.wanjohichristopher.com.conf /etc/nginx/sites-available/
sudo ln -sf /etc/nginx/sites-available/voiceai.wanjohichristopher.com.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
echo -e "${GREEN}✓ Nginx configured${NC}"

# Step 6: Install SSL with Certbot
echo -e "${CYAN}[6/6] Setting up SSL with Let's Encrypt...${NC}"
sudo apt install certbot python3-certbot-nginx -y
echo ""
echo -e "${CYAN}Running Certbot for SSL certificate...${NC}"
sudo certbot --nginx -d voiceai.wanjohichristopher.com --non-interactive --agree-tos --email your-email@example.com || {
    echo -e "${RED}Note: Certbot failed. Make sure DNS is configured first.${NC}"
    echo "Run manually later: sudo certbot --nginx -d voiceai.wanjohichristopher.com"
}

echo ""
echo "============================================"
echo -e "${GREEN}🎉 Deployment Complete!${NC}"
echo "============================================"
echo ""
echo "Your Voice AI Hub is now live at:"
echo -e "${CYAN}https://voiceai.wanjohichristopher.com${NC}"
echo ""
echo "Files location: /var/www/voiceai/"
echo "Nginx config: /etc/nginx/sites-available/voiceai.wanjohichristopher.com.conf"
echo ""
