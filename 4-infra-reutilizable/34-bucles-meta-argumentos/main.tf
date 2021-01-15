# -------------------------
# Define el provider de AWS
# -------------------------
provider "aws" {
  region = "eu-west-1"
}

# ---------------------------------------
# Define una instancia EC2 con AMI Ubuntu
# ---------------------------------------
resource "aws_instance" "mi_servidor" {
  count = 2

  ami           = "ami-0aef57767f5404a3c"
  instance_type = "t2.micro"
}

