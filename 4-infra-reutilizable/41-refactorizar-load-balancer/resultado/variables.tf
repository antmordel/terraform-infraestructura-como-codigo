variable "puerto_servidor" {
  description = "Puerto para las instancias EC2"
  type        = number
  default     = 8080

  validation {
    condition     = var.puerto_servidor > 0 && var.puerto_servidor <= 65536
    error_message = "El valor del puerto debe estar comprendido entre 1 y 65536."
  }
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

variable "ubuntu_ami" {
  description = "AMI por region"
  type        = map(string)

  default = {
    eu-west-1 = "ami-0aef57767f5404a3c" # Ubuntu en Dublin
    us-west-2 = "ami-005383956f2e5fb96" # Ubuntu en London
  }
}

variable "servidores" {
  description = "Mapa de servidores con su correspondiente AZ"

  type = map(object({
    nombre = string,
    az     = string
    })
  )

  default = {
    "ser-1" = { nombre = "servidor-1", az = "a" },
    "ser-2" = { nombre = "servidor-2", az = "b" },
    "ser-3" = { nombre = "servidor-3", az = "c" }
  }
}
