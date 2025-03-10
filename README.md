# Déploiement d'une Instance EC2 avec Nginx, Certbot et Docker

Ce projet Terraform automatise le déploiement d'une instance EC2 sur AWS avec **Nginx en tant que reverse proxy**, **Let's Encrypt pour le SSL** et **Docker pour exécuter une application**.

## Fonctionnalités

- ✅ Déploiement automatique d'une instance EC2 sous Ubuntu
- ✅ Installation de Nginx et configuration du reverse proxy
- ✅ Gestion automatique du SSL via Let's Encrypt (Certbot)
- ✅ Redirection HTTP → HTTPS
- ✅ Support du sous-domaine (`app.ton-domaine.com`)
- ✅ Préparation pour l’installation manuelle d'une application en Docker

## Architecture

- **AWS EC2 (t3.micro, Free Tier)**
- **Nginx** (reverse proxy pour ton application Docker)
- **Certbot (Let's Encrypt)** (sécurise l'application avec SSL)
- **Docker** (exécutera ton application après installation manuelle)

## Prérequis

Avant de commencer, assure-toi d'avoir :

1. **Un compte AWS** avec une **clé SSH (`.pem`)** pour te connecter à l'instance.
2. **Terraform installé** (`>= 1.0`) - [Télécharger Terraform](https://www.terraform.io/downloads.html)
3. **Un domaine chez GoDaddy ou chez un autre fournisseur** et la possibilité de modifier les enregistrements DNS.
4. **Un sous-domaine configuré (`app.ton-domaine.com`)** qui pointera vers l'instance EC2.

## Étapes d'installation

### 1️⃣ Cloner le projet

```sh
git clone https://github.com/mdci-projets/terraform-nginx-ssl.git
cd terraform-nginx-ssl
```

### 2️⃣ Modifier les variables

Édite **`terraform.tfvars`** pour **remplacer par ton domaine et ton email** :

```hcl
aws_region  = "us-east-1"
domain_name = "app.ton-domaine.com"
email       = "ton-email@example.com"
key_name        = "ton-key-paire"
```

### 3️⃣ Initialiser Terraform

```sh
terraform init
```

### 4️⃣ Vérifier la configuration

```sh
terraform plan
```

### 5️⃣ Déployer l'infrastructure

```sh
terraform apply -auto-approve
```

### 6️⃣ Ajouter l'IP publique à GoDaddy

Une fois Terraform terminé, récupère l'IP publique de ton serveur :

```sh
terraform output server_ip
```

**Sur GoDaddy ou ton fournisseur de domaine:**
- **Ajoute un enregistrement `A`** pour `app.ton-domaine.com` qui pointe vers cette IP.

💡 **Attends quelques minutes** que les DNS se propagent.

### 7️⃣ Vérifier l'accès

Une fois la propagation DNS terminée, **teste en visitant** :

```
http://app.ton-domaine.com
```

Tu devrais voir la page `"Configuration en cours pour app.ton-domaine.com"`.

### 8️⃣ Installer le certificat SSL

Une fois le sous-domaine actif, connecte-toi en SSH à l'instance :

```sh
ssh -i my-key.pem ubuntu@<IP_PUBLIC>
```

Puis exécute Certbot pour obtenir le certificat SSL :

```sh
sudo certbot --nginx -d app.ton-domaine.com --non-interactive --agree-tos -m ton-email@example.com
```

### 9️⃣ Vérifier le certificat SSL

```sh
sudo certbot certificates
```

### 🔟 Activer la redirection HTTP → HTTPS

Modifie la configuration Nginx :

```sh
sudo nano /etc/nginx/sites-available/app.ton-domaine.com
```

Ajoute cette redirection :

```nginx
server {
    listen 80;
    server_name app.ton-domaine.com;
    return 301 https://app.ton-domaine.com$request_uri;
}

server {
    listen 443 ssl;
    server_name app.ton-domaine.com;

    ssl_certificate /etc/letsencrypt/live/app.ton-domaine.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/app.ton-domaine.com/privkey.pem;

    location / {
        proxy_pass http://localhost:8080;  # Redirection vers le conteneur Docker
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

Puis redémarre Nginx :

```sh
sudo systemctl restart nginx
```

Maintenant, **HTTP est automatiquement redirigé vers HTTPS**. 🎉

## 📌 Déploiement de l’application Docker

Une fois tout en place, lance ton application dans un conteneur Docker :

```sh
docker run -d --name my-app -p 8080:80 my-docker-image
```

Vérifie que ton application fonctionne en visitant :

```
https://app.ton-domaine.com
```

## 📌 Gestion et Maintenance

🔹 **Lister les instances Terraform** :

```sh
terraform state list
```

🔹 **Détruire l’infrastructure si besoin** :

```sh
terraform destroy -auto-approve
```

🔹 **Renouveler manuellement le certificat SSL** :

```sh
sudo certbot renew
```

🔹 **Vérifier les logs Nginx** en cas de problème :

```sh
sudo journalctl -xeu nginx.service
```

## Améliorations possibles

- 🚀 **Automatiser la gestion du DNS avec GoDaddy API**
- 🚀 **Utiliser Docker Compose pour gérer plusieurs services**
- 🚀 **Ajouter du monitoring (Prometheus, Grafana)**

## Auteur

👨‍💻 **Développé par Youssef Massaoudi**  
💡 **Contact :** y.massaoudi@yahoo.fr  
🚀 **Projet GitHub :** [github.com/ton-repo]  
