# -------------------------
# Define el provider de AWS
# -------------------------
provider "aws" {
  region = local.region
}

locals {
  region          = "eu-west-1"
  ami             = var.ubuntu_ami[local.region]
  puerto_lb       = 80
  puerto_servidor = 8080
}

# ------------------------------------
# Data source que obtiene el id del AZ
# ------------------------------------
data "aws_subnet" "public_subnet" {
  for_each = var.servidores

  availability_zone = "${local.region}${each.value.az}"
}

module "servidores_ec2" {
  source = "../../modulos/instancias-ec2"

  tipo_instancia = "t2.nano"

  servidores = {
    for id_ser, datos in var.servidores :
    id_ser => { nombre = datos.nombre, subnet_id = data.aws_subnet.public_subnet[id_ser].id }
  }

  puerto_servidor = local.puerto_servidor
  ami_id          = var.ubuntu_ami[local.region]
}

module "load_balancer" {
  source = "../../modulos/loadbalancer"

  subnet_ids      = [for subnet in data.aws_subnet.public_subnet : subnet.id]
  instancia_ids   = module.servidores_ec2.instancia_ids
  puerto_lb       = local.puerto_lb
  puerto_servidor = local.puerto_servidor
}

