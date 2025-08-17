terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "random_password" "secret" {
  length  = 24
  special = true
}

resource "aws_secretsmanager_secret" "secrets" {
  name        = "${var.secret_name}-${random_id.unique_id.hex}"      
  description = var.description

  tags = {
    Environment = "production"
    App         = "3-tier"
  }
}

resource "random_id" "unique_id" {
  byte_length = 4
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id     = aws_secretsmanager_secret.secrets.id
  secret_string = jsonencode({
    username = var.username
    password = random_password.secret.result
  })
}
