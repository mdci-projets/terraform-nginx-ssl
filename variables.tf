variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "us-east-1"
}

variable "access_key" {}
variable "secret_key" {}

variable "ami_id" {
  description = "ID de l'AMI Ubuntu"
  type        = string
  default     = "ami-04b4f1a9cf54c11d0" # Ubuntu 22.04 LTS
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "name d'instance EC2"
  type        = string
  default     = "nginx-server"
}

variable "key_name" {
  description = "Nom de la clé SSH"
  type        = string
  default     = "my-key"
}

variable "domain_name" {
  description = "Nom de domaine utilisé pour SSL"
  type        = string
}

variable "email" {
  description = "Email pour Certbot"
  type        = string
}

variable "ssh_ip" {
  description = "Adresse IP autorisée pour SSH"
  type        = string
  default     = "XX.XX.XX.XX/32"  # Mets ici ton IP publique
}