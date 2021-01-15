# -------------------------
# Define el provider de AWS
# -------------------------
provider "aws" {
  region = "eu-west-1"
}

# ---------------------------------
# Define número de usuarios a crear
# ---------------------------------
variable "usuarios" {
  description = "Nombre de usuarios IAM"
  type        = list(string)
}


# ---------------------------------
# Crea un <var.usuarios> de IAM
# ---------------------------------
resource "aws_iam_user" "ejemplo" {
  count = length(var.usuarios)

  name = "usuario-${var.usuarios[count.index]}"
}

