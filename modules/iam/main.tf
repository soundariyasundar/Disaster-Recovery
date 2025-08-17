resource "aws_iam_role" "cluster_role" {
  name = var.iam_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = var.aws_service
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  for_each   = toset(var.policy_arns)
  role       = aws_iam_role.cluster_role.name
  policy_arn = each.value
}

