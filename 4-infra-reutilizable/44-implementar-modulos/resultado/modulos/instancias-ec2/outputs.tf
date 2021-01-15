output "instancia_ids" {
  description = "IDs de las instancias"
  value       = [for servidor in aws_instance.servidor : servidor.id]
}
