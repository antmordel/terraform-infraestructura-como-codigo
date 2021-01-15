# Solamente de ejemplo! No ejecutar!
provider "aws" {
  region = "eu-west-1"
}

module "ec2_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "servidor-1"
  instance_count = 1

  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

}
