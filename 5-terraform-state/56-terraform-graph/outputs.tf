output "dns_load_balancer" {
  description = "DNS pública del load balancer"
  value       = module.load_balancer.dns_load_balancer
}
