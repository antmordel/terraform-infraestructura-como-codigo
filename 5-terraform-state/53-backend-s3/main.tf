terraform {
  backend "s3" {
    bucket = "terraform-infraestructura-como-codigo"
    key    = "servidor/terraform.tfstate"
    region = "eu-west-1"

    dynamodb_table = "terraform-infraestructura-como-codigo-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-infraestructura-como-codigo"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-infraestructura-como-codigo-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_instance" "servidor" {
  ami           = "ami-0aef57767f5404a3c"
  instance_type = "t2.micro"
}
