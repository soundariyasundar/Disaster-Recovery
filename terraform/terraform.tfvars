primary_region = "us-east-1"
dr_region      = "ap-south-1"

primary_vpc_cidr              = "10.10.0.0/16"
primary_vpc_name              = "us-east-1-main-vpc"
primary_azs                   = ["us-east-1a", "us-east-1b"]
primary_public_subnet_cidrs   = ["10.10.1.0/24", "10.10.2.0/24"]
primary_private_subnet_cidrs  = ["10.10.11.0/24", "10.10.12.0/24"]
primary_db_subnet_cidrs       = ["10.10.13.0/24", "10.10.14.0/24"]
primary_nat_gw_subnet_indexes = [0, 1]

dr_vpc_cidr              = "10.20.0.0/16"
dr_vpc_name              = "ap-south-1-dr-vpc"
dr_azs                   = ["ap-south-1a", "ap-south-1b"]
dr_public_subnet_cidrs   = ["10.20.1.0/24", "10.20.2.0/24"]
dr_private_subnet_cidrs  = ["10.20.11.0/24", "10.20.12.0/24"]
dr_db_subnet_cidrs       = ["10.20.13.0/24", "10.20.14.0/24"]
dr_nat_gw_subnet_indexes = [0, 1]

allowed_ssh_cidrs   = ["60.243.95.65/32"]
allowed_nginx_cidrs = ["0.0.0.0/0"]
allowed_db_cidrs    = ["10.10.0.0/16", "10.20.0.0/16"]

name              = "RDSdb"
db_instance_class = "db.t3.medium"
db_username       = "admin"
db_password       = "SuperSecret123!"
db_engine_version = "8.0"

eks_cluster_version    = "1.32"
eks_node_instance_type = "t3.medium"
eks_node_count         = 2
eks_api_cidrs          = ["60.243.95.65/32"]

allowed_http_cidrs = ["0.0.0.0/0"]


key_name = "key-pair-crr"

nginx_name                = "primary"
nginx_type                = "nginx"
nginx_instance_count      = 2
nginx_ami_primary         = "ami-0de716d6197524dd9"
nginx_ami_dr              = "ami-0144277607031eca2"
nginx_instance_type       = "t3.medium"
nginx_associate_public_ip = false

bastion_name                = "primary"
bastion_type                = "bastion"
bastion_instance_count      = 2
bastion_ami_primary         = "ami-0de716d6197524dd9"
bastion_ami_dr              = "ami-0144277607031eca2"
bastion_instance_type       = "t3.medium"
bastion_associate_public_ip = true


infra_name                = "primary"
infra_type                = "infra"
infra_instance_count      = 1
infra_ami_primary         = "ami-0de716d6197524dd9"
infra_instance_type       = "t2.micro"
infra_associate_public_ip = false


secret_name = "rds-secret"
description = "RDS credentials for MyApp"
username    = "admin"

ecr_frontend_name = "frontend"
ecr_backend_name  = "backend"

ecr_image_tag_mutability = "MUTABLE"
ecr_scan_on_push         = true

ecr_frontend_tags = {
  "project"   = "project"
  "component" = "frontend"
}

ecr_backend_tags = {
  "project"   = "project"
  "component" = "backend"
}

# Example: Replicate frontend repo to another region
ecr_frontend_replication_destinations = [
  {
    region      = "ap-south-1"
    registry_id = "804363747200"
  }
]
ecr_backend_replication_destinations = []

replication_destinations = [
  {
    region      = "ap-south-1"
    registry_id = "804363747200"
  }
]

root_volume_size = 30

eks_cluster_role_name        = "eks-cluster-role"
eks_cluster_trusted_services = ["eks.amazonaws.com"]
eks_cluster_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
]

eks_node_group_role_name        = "eks-node-group-role"
eks_node_group_trusted_services = ["ec2.amazonaws.com"]
eks_node_group_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
]

rds_mysql_role_name    = "RDS-monitoring-role"
rds_mysql_aws_services = ["monitoring.rds.amazonaws.com"]
rds_mysql_policy_arns = [
  "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
]

