variable "variable_dinamica" {
  type = list(any)
}

output "valor_variable_dinamica" {
  value = var.variable_dinamica
}
