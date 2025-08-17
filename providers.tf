terraform {
  backend "s3" {
    bucket = "s3backendstate12041204"
    dynamodb_table = "terraform-locks"
    key = "mystatefile/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.primary_region
}
provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

provider "aws" {
  alias  = "dr"
  region = var.dr_region
}


