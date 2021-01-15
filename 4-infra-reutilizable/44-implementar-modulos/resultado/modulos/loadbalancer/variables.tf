variable "subnet_ids" {
  description = "Todos los ids de las subnets donde el ALB es provisionado"
  type        = set(string)
}

variable "instancia_ids" {
  description = "Ids de todas las instancias"
  type        = list(string)
}

variable "puerto_lb" {
  description = "Puerto para el Load Balancer"
  type        = number
  default     = 80
}

variable "puerto_servidor" {
  description = "Puerto para las instancias EC2"
  type        = number
  default     = 8080

  validation {
    condition     = var.puerto_servidor > 0 && var.puerto_servidor <= 65536
    error_message = "El valor del puerto debe estar comprendido entre 1 y 65536."
  }
}
