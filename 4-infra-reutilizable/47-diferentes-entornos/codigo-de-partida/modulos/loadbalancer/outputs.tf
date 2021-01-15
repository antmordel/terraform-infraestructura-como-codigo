output "dns_load_balancer" {
  description = "DNS pública del load balancer"
  value       = "http://${aws_lb.alb.dns_name}:${var.puerto_lb}"
}
