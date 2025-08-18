terraform {
  backend "s3" {
    bucket         = "s3crossregionbucket1234"
    key            = "statefile/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "crossregiontable-12"
  }
}