provider "aws" {
  region = "us-east-1" # Change region if needed
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "s3backendstatefile12041204"  # Must be globally unique!
  acl    = "private"
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
  tags = {
    Name = "Terraform State Bucket"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "Terraform Lock Table"
  }
}

resource "aws_iam_user" "terraform" {
  name = "terraform-backend-user"
  tags = {
    Description = "User for Terraform remote backend"
  }
}

resource "aws_iam_user_policy" "terraform" {
  name = "TerraformBackendS3Policy"
  user = aws_iam_user.terraform.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.tf_state.arn,
          "${aws_s3_bucket.tf_state.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ]
        Resource = aws_dynamodb_table.tf_lock.arn
      }
    ]
  })
}
