output "server_ip" {
  value = module.ec2_nginx.public_ip
  description = "Ajoute cette IP dans GoDaddy"
}
