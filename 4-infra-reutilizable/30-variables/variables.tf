variable "puerto_servidor" {
  description = "Puerto para las instancias EC2"
  type        = number
  default     = 8080
}

variable "puerto_lb" {
  description = "Puerto para el Load Balancer"
  type        = number
  default     = 80
}

variable "tipo_instancia" {
  description = "Tipo de la instancia EC2"
  type        = string
  default     = "t2.micro"
}
