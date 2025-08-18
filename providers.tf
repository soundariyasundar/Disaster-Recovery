terraform {
<<<<<<< HEAD
  
=======
  backend "s3" {
    bucket = "s3backendstatefile12041204"
    dynamodb_table = "terraform-locks"
    key = "mystatefile/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
>>>>>>> 7c8e52474c6a1f3c12aa893475b31af542cad3c0
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


