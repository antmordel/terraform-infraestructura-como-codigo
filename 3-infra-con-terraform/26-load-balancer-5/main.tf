# -------------------------
# Define el provider de AWS
# -------------------------
provider "aws" {
  region = "eu-west-1"
}

# -----------------------------------------------
# Data source que obtiene el id del AZ eu-west-1a
# -----------------------------------------------
data "aws_subnet" "az_a" {
  availability_zone = "eu-west-1a"
}

# -----------------------------------------------
# Data source que obtiene el id del AZ eu-west-1a
# -----------------------------------------------
data "aws_subnet" "az_b" {
  availability_zone = "eu-west-1b"
}

# ---------------------------------------
# Define una instancia EC2 con AMI Ubuntu
# ---------------------------------------
resource "aws_instance" "servidor_1" {
  ami                    = "ami-0aef57767f5404a3c"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.az_a.id
  vpc_security_group_ids = [aws_security_group.mi_grupo_de_seguridad.id]

  // Escribimos un "here document" que es
  // usado durante la inicialización
  user_data = <<-EOF
              #!/bin/bash
              echo "Hola Terraformers! Soy servidor 1" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags = {
    Name = "servidor-1"
  }
}

# ----------------------------------------------
# Define la segunda instancia EC2 con AMI Ubuntu
# ----------------------------------------------
resource "aws_instance" "servidor_2" {
  ami                    = "ami-0aef57767f5404a3c"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.az_b.id
  vpc_security_group_ids = [aws_security_group.mi_grupo_de_seguridad.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hola Terraformers! Soy servidor 2" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags = {
    Name = "servidor-2"
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
    from_port       = 8080
    to_port         = 8080
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

  subnets = [data.aws_subnet.az_a.id, data.aws_subnet.az_b.id]
}

# ------------------------------------
# Security group para el Load Balancer
# ------------------------------------
resource "aws_security_group" "alb" {
  name = "alb-sg"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acceso al puerto 80 desde el exterior"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acceso al puerto 8080 de nuestros servidores"
    from_port   = 8080
    to_port     = 8080
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
  port     = 80
  vpc_id   = data.aws_vpc.default.id
  protocol = "HTTP"

  health_check {
    enabled  = true
    matcher  = "200"
    path     = "/"
    port     = "8080"
    protocol = "HTTP"
  }
}

# -----------------------------
# Attachment para el servidor 1
# -----------------------------
resource "aws_lb_target_group_attachment" "servidor_1" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.servidor_1.id
  port             = 8080
}

# -----------------------------
# Attachment para el servidor 2
# -----------------------------
resource "aws_lb_target_group_attachment" "servidor_2" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.servidor_2.id
  port             = 8080
}

# ------------------------
# Listener para nuestro LB
# ------------------------
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80

  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type             = "forward"
  }
}
