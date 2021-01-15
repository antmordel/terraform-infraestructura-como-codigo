# ---------------------------------------
# Define una instancia EC2 con AMI Ubuntu
# ---------------------------------------
resource "aws_instance" "servidor" {
  for_each = var.servidores

  ami                    = var.ami_id
  instance_type          = var.tipo_instancia
  subnet_id              = each.value.subnet_id
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

resource "random_pet" "sg" {
  length = 1
}

# ------------------------------------------------------
# Define un grupo de seguridad con acceso al puerto 8080
# ------------------------------------------------------
resource "aws_security_group" "mi_grupo_de_seguridad" {
  name = "servidor-sg-${random_pet.sg.id}"

  ingress {
    description = "Acceso al puerto del servidor desde el LB"
    from_port   = var.puerto_servidor
    to_port     = var.puerto_servidor
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
