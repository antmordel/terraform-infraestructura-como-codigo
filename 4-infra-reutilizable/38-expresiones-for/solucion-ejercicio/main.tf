# -------------------------
# Define el provider de AWS
# -------------------------
provider "aws" {
  region = "eu-west-1"
}

variable "usuarios" {
  description = "Nombre usuarios IAM"
  type        = set(string)
  default     = ["maria", "manuel"]
}

resource "aws_iam_user" "ejemplo" {
  for_each = var.usuarios

  name = "usuario-${each.value}"
}

output "arn_usuario" {
  value = aws_iam_user.ejemplo["manuel"].arn
}

output "nombre_a_arn" {
  value = { for usuario in aws_iam_user.ejemplo : usuario.name => usuario.arn }
}

output "nombres_usuarios" {
  value = [for usuario in aws_iam_user.ejemplo : usuario.name]
}
