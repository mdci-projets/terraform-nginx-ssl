#!/bin/bash

DOMAIN="${domain_name}"
EMAIL="${email}"

# Mise à jour et installation des paquets nécessaires
sudo apt update -y
sudo apt install -y nginx certbot python3-certbot-nginx docker.io at -y
sudo systemctl enable --now atd
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
sudo chown ubuntu:docker /var/run/docker.sock
sudo chmod 666 /var/run/docker.sock

# Création d'un Virtual Host Nginx temporaire pour servir une page d'attente
sudo bash -c "cat > /etc/nginx/sites-available/$DOMAIN <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        root /var/www/html;
        index index.html;
    }

    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }
}
EOF"

# Activer le site et redémarrer Nginx
sudo ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
echo "<h1>Configuration en cours pour $DOMAIN</h1>" | sudo tee /var/www/html/index.html
sudo systemctl restart nginx

# Indication pour l'utilisateur
echo "Nginx installé, mais Certbot ne sera pas exécuté automatiquement."
echo "Ajoutez l'IP de l'instance à GoDaddy pour $DOMAIN, puis exécutez Certbot manuellement."

