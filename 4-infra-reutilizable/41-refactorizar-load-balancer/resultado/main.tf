# -------------------------
# Define el provider de AWS
# -------------------------
provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-1"
  ami    = var.ubuntu_ami[local.region]
}

# ------------------------------------
# Data source que obtiene el id del AZ
# ------------------------------------
data "aws_subnet" "public_subnet" {
  for_each = var.servidores

  availability_zone = "${local.region}${each.value.az}"
}

# ---------------------------------------
# Define una instancia EC2 con AMI Ubuntu
# ---------------------------------------
resource "aws_instance" "servidor" {
  for_each = var.servidores

  ami                    = local.ami
  instance_type          = var.tipo_instancia
  subnet_id              = data.aws_subnet.public_subnet[each.key].id
  vpc_security_group_ids = [aws_security_group.mi_grupo_de_seguridad.id]

  // Escribimos un "here document" que es
  // usado durante la inicialización
  user_data = <<-EOF
              #!/bin/bash
              echo "Hola Terraformers! Soy ${each.value.nombre}" > index.html
              nohup busybox httpd -f -p ${var.puerto_servidor} &
              EOF

  tags = {
    Name = each.value.nombre
  }
}

# ------------------------------------------------------
# Define un grupo de seguridad con acceso al puerto 8080
# ------------------------------------------------------
resource "aws_security_group" "mi_grupo_de_seguridad" {
  name = "primer-servidor-sg"

  ingress {
    security_groups = [aws_security_group.alb.id]
    description     = "Acceso al puerto 8080 desde el exterior"
    from_port       = var.puerto_servidor
    to_port         = var.puerto_servidor
    protocol        = "TCP"
  }
}

# ----------------------------------------
# Load Balancer público con dos instancias
# ----------------------------------------
resource "aws_lb" "alb" {
  load_balancer_type = "application"
  name               = "terraformers-alb"
  security_groups    = [aws_security_group.alb.id]

  subnets = [for subnet in data.aws_subnet.public_subnet : subnet.id]
}

# ------------------------------------
# Security group para el Load Balancer
# ------------------------------------
resource "aws_security_group" "alb" {
  name = "alb-sg"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acceso al puerto 80 desde el exterior"
    from_port   = var.puerto_lb
    to_port     = var.puerto_lb
    protocol    = "TCP"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acceso al puerto 8080 de nuestros servidores"
    from_port   = var.puerto_servidor
    to_port     = var.puerto_servidor
    protocol    = "TCP"
  }
}

# ----------------------------------------------------
# Data Source para obtener el ID de la VPC por defecto
# ----------------------------------------------------
data "aws_vpc" "default" {
  default = true
}

# ----------------------------------
# Target Group para el Load Balancer
# ----------------------------------
resource "aws_lb_target_group" "this" {
  name     = "terraformers-alb-target-group"
  port     = var.puerto_lb
  vpc_id   = data.aws_vpc.default.id
  protocol = "HTTP"

  health_check {
    enabled  = true
    matcher  = "200"
    path     = "/"
    port     = var.puerto_servidor
    protocol = "HTTP"
  }
}

# ------------------------------
# Attachment para los servidores
# ------------------------------
resource "aws_lb_target_group_attachment" "servidor" {
  for_each = var.servidores

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.servidor[each.key].id
  port             = var.puerto_servidor
}

# ------------------------
# Listener para nuestro LB
# ------------------------
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.puerto_lb

  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type             = "forward"
  }
}
