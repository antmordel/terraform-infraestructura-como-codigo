# -------------------------
# Define el provider de AWS
# -------------------------
provider "aws" {
  region = "eu-west-1"
}

variable "usuarios" {
  description = "Numero usuarios IAM"
  type        = number
}

resource "aws_iam_user" "ejemplo" {
  count = var.usuarios

  name = "usuario.${count.index}"
}

output "arn_usuario" {
  value = aws_iam_user.ejemplo[2].arn
}

output "arn_todos_usuarios" {
  value = [for usuario in aws_iam_user.ejemplo : usuario.arn]
}
