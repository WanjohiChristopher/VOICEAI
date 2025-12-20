# 🎙️ Voice AI Hub - Deployment Guide

## Domain: voiceai.wanjohichristopher.com

---

## 📁 Package Contents

```
voiceai-deploy/
├── index.html                              # Main website file
├── voice_ai_arch.gif                       # Your architecture diagram
├── voiceai.wanjohichristopher.com.conf     # Nginx configuration
├── deploy.sh                               # Automated deployment script
└── README.md                               # This guide
```

---

## 🚀 Quick Deployment (3 Steps)

### Step 1: Upload Files to EC2

```bash
# From your local machine, upload the deployment folder
scp -i your-key.pem -r voiceai-deploy/ ubuntu@YOUR_EC2_IP:~/
```

### Step 2: Run Deployment Script

```bash
# SSH into your EC2 instance
ssh -i your-key.pem ubuntu@YOUR_EC2_IP

# Navigate to the folder and run the script
cd voiceai-deploy
chmod +x deploy.sh
./deploy.sh
```

### Step 3: Configure DNS (see below)

---

## 📋 Manual Deployment Steps

If you prefer to do it manually:

### 1️⃣ Install Nginx

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
```

### 2️⃣ Create Website Directory

```bash
sudo mkdir -p /var/www/voiceai
sudo chown -R $USER:$USER /var/www/voiceai
```

### 3️⃣ Copy Website Files

```bash
cp index.html /var/www/voiceai/
cp voice_ai_arch.gif /var/www/voiceai/
```

### 4️⃣ Configure Nginx

```bash
# Copy the config file
sudo cp voiceai.wanjohichristopher.com.conf /etc/nginx/sites-available/

# Enable the site
sudo ln -sf /etc/nginx/sites-available/voiceai.wanjohichristopher.com.conf /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

### 5️⃣ Set Up SSL (HTTPS)

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d voiceai.wanjohichristopher.com
```

---

## 🌐 DNS Configuration

### Option A: Using Route 53 (if wanjohichristopher.com is on AWS)

1. Go to **Route 53** → **Hosted Zones** → **wanjohichristopher.com**
2. Click **Create Record**
3. Configure:
   - **Record name:** `voiceai`
   - **Record type:** `A`
   - **Value:** `YOUR_EC2_PUBLIC_IP`
   - **TTL:** `300`
4. Click **Create records**

### Option B: Using Other DNS Providers (Cloudflare, GoDaddy, Namecheap, etc.)

Add an **A Record**:
| Type | Name | Value | TTL |
|------|------|-------|-----|
| A | voiceai | YOUR_EC2_PUBLIC_IP | 300 |

### Option C: Using Elastic IP (Recommended)

1. Go to **EC2** → **Elastic IPs** → **Allocate Elastic IP address**
2. **Associate** the Elastic IP with your EC2 instance
3. Use the Elastic IP in your DNS A record

> ⚠️ **Important:** Use an Elastic IP so your IP doesn't change when you stop/start the instance.

---

## 🔒 EC2 Security Group Configuration

Make sure your EC2 security group allows:

| Type | Protocol | Port | Source |
|------|----------|------|--------|
| HTTP | TCP | 80 | 0.0.0.0/0 |
| HTTPS | TCP | 443 | 0.0.0.0/0 |
| SSH | TCP | 22 | Your IP |

### To update Security Group:

1. Go to **EC2** → **Security Groups**
2. Select your instance's security group
3. **Edit inbound rules**
4. Add HTTP (80) and HTTPS (443) if not present

---

## ✅ Verification Checklist

After deployment, verify:

- [ ] `http://YOUR_EC2_IP` shows the website
- [ ] DNS propagated: `nslookup voiceai.wanjohichristopher.com`
- [ ] `http://voiceai.wanjohichristopher.com` loads
- [ ] SSL works: `https://voiceai.wanjohichristopher.com`
- [ ] Architecture GIF animates properly

---

## 🔧 Troubleshooting

### Website not loading?

```bash
# Check Nginx status
sudo systemctl status nginx

# Check Nginx error logs
sudo tail -f /var/log/nginx/error.log

# Test Nginx config
sudo nginx -t
```

### DNS not resolving?

```bash
# Check DNS propagation
nslookup voiceai.wanjohichristopher.com
dig voiceai.wanjohichristopher.com

# DNS can take up to 48 hours, but usually 5-30 minutes
```

### SSL certificate failed?

```bash
# Make sure DNS is working first, then run:
sudo certbot --nginx -d voiceai.wanjohichristopher.com

# Or debug with:
sudo certbot --nginx -d voiceai.wanjohichristopher.com --dry-run
```

### Permission denied?

```bash
# Fix permissions
sudo chown -R www-data:www-data /var/www/voiceai
sudo chmod -R 755 /var/www/voiceai
```

---

## 📝 Updating the Website

To update the website later:

```bash
# SSH into EC2
ssh -i your-key.pem ubuntu@YOUR_EC2_IP

# Replace the files
sudo cp new-index.html /var/www/voiceai/index.html

# Clear browser cache or hard refresh (Ctrl+Shift+R)
```

---

## 🎉 You're Done!

Your Voice AI Hub will be live at:

🔗 **https://voiceai.wanjohichristopher.com**

---

## 📞 Quick Reference Commands

```bash
# Restart Nginx
sudo systemctl restart nginx

# View Nginx logs
sudo tail -f /var/log/nginx/access.log

# Renew SSL (auto-renews, but manual if needed)
sudo certbot renew

# Check SSL expiry
sudo certbot certificates
```

---

Created by Chris Wanjohi | Voice AI Architecture Expert
