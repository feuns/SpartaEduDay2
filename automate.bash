#!/bin/bash

echo "starting sparta app deployment..."

# update system
sudo apt update && sudo apt upgrade -y

# install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# install NGINX
sudo apt install -y nginx

# setup app directory
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app

# install PM2 globally
sudo npm install -g pm2

# start app
pm2 start app.js --name sparta-test-app
pm2 save

# nginx config
sudo tee /etc/nginx/sites-available/sparta-test-app > /dev/null << 'EOF'
server {
    listen 80;
    server_name _;
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

sudo rm -f /etc/nginx/sites-enabled/default
sudo ln -sf /etc/nginx/sites-available/sparta-test-app /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

echo "deployment complete :D"