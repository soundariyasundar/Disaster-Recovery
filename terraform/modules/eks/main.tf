terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cluster_ingress_cidrs
    description = "Allow Kubernetes API access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.cluster_name}-cluster-sg"
  }
}

resource "aws_eks_cluster" "App" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role
  version  = var.cluster_version

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.eks_cluster.id]
    endpoint_private_access = true   
    endpoint_public_access  = true  
  }

  tags = {
    Name = var.cluster_name
  }
}

resource "aws_eks_node_group" "ng1" {
  cluster_name    = aws_eks_cluster.App.name
  node_group_name = "${var.cluster_name}-ng1"
  node_role_arn   = var.eks_node_role
  subnet_ids      = [var.subnet_ids[1]]
  instance_types  = [var.node_instance_type]
  scaling_config {
    desired_size = var.node_count
    max_size     = var.node_count
    min_size     = 1
  }
  depends_on = [
    aws_eks_cluster.App,
  ]
}

resource "aws_eks_node_group" "ng2" {
  cluster_name    = aws_eks_cluster.App.name
  node_group_name = "${var.cluster_name}-ng2"
  node_role_arn   = var.eks_node_role
  subnet_ids      = [var.subnet_ids[1]]
  instance_types  = [var.node_instance_type]
  scaling_config {
    desired_size = var.node_count
    max_size     = var.node_count
    min_size     = 1
  }
  depends_on = [
    aws_eks_cluster.App,
  ]
}
