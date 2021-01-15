# -------------------------
# Define el provider de AWS
# -------------------------
provider "aws" {
  region = "eu-west-1"
}

variable "usuarios" {
  description = "Numero usuarios IAM"
  type        = set(string)
}

resource "aws_iam_user" "ejemplo" {
  for_each = var.usuarios

  name = "usuario-${each.value}"
}

output "arn_usuario" {
  description = "ARN del usuario maria"
  value       = aws_iam_user.ejemplo["maria"].arn
}

output "arn_todos_usuarios" {
  description = "ARN todos los usuarios"
  value       = [for usuario in aws_iam_user.ejemplo : usuario.arn]
}

