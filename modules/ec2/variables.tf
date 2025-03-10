variable "ami_id" {
  description = "ID de l'AMI Ubuntu"
  type        = string
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
}

variable "key_name" {
  description = "Nom de la clé SSH"
  type        = string
}

variable "instance_name" {
  description = "Nom de l'instance EC2"
  type        = string
}

variable "domain_name" {
  description = "Nom de domaine utilisé pour le SSL"
  type        = string
}

variable "email" {
  description = "Email pour Certbot"
  type        = string
}

variable "ssh_ip" {
  description = "Adresse IP publique autorisée pour SSH"
  type        = string
}
