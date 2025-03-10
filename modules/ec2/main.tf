resource "aws_security_group" "nginx_sg" {
  name        = "nginx-security-group"
  description = "Autorise HTTP, HTTPS et SSH"

  # Autoriser HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser SSH uniquement depuis ton IP (remplace par ton IP publique)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_ip]  # Mets ici ton IP publique
  }

  # Autoriser le trafic vers l'application Docker (8080) en local
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["127.0.0.1/32"]  # Accessible uniquement en local
  }

  # Autoriser tout le trafic sortant
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  associate_public_ip_address = true

  security_groups = [aws_security_group.nginx_sg.name]
  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    domain_name = var.domain_name
    email       = var.email
  })

  tags = {
    Name = var.instance_name
  }
}
