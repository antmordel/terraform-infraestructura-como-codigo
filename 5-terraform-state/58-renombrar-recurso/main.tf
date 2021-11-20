provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "servidor_micro" {
  ami           = "ami-02b4e72b17337d6c1"
  instance_type = "t2.micro"
}
