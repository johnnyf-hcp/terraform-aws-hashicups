# Outputs file
output "app_url" {
  value = "http://${aws_instance.hashicups-docker-server.public_dns}"
}

output "app_ip" {
  value = "http://${aws_instance.hashicups-docker-server.public_ip}"
}