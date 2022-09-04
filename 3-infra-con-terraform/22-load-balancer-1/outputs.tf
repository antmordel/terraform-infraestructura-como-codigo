output "dns_publica_server1" {
  description = "DNS pública del servidor 1"
  value       = "http://${aws_instance.servidor_1.public_dns}:8080"
}

output "dns_publica_server2" {
  description = "DNS pública del servidor 2"
  value       = "http://${aws_instance.servidor_2.public_dns}:8080"
}
