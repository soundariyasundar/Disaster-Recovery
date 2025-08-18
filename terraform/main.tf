module "vpc_primary" {
  source                = "./modules/vpc"
  providers             = { aws = aws.primary }
  vpc_cidr              = var.primary_vpc_cidr
  vpc_name              = var.primary_vpc_name
  azs                   = var.primary_azs
  public_subnet_cidrs   = var.primary_public_subnet_cidrs
  private_subnet_cidrs  = var.primary_private_subnet_cidrs
  db_subnet_cidrs       = var.primary_db_subnet_cidrs
  nat_gw_subnet_indexes = var.primary_nat_gw_subnet_indexes
}
module "vpc_dr" {
  source                = "./modules/vpc"
  providers             = { aws = aws.dr }
  vpc_cidr              = var.dr_vpc_cidr
  vpc_name              = var.dr_vpc_name
  azs                   = var.dr_azs
  public_subnet_cidrs   = var.dr_public_subnet_cidrs
  private_subnet_cidrs  = var.dr_private_subnet_cidrs
  db_subnet_cidrs       = var.dr_db_subnet_cidrs
  nat_gw_subnet_indexes = var.dr_nat_gw_subnet_indexes
}

module "sg_bastion_primary" {
  source = "./modules/sg"
  providers = {
    aws = aws.primary
  }
  name   = "primary"
  type   = "bastion"
  vpc_id = module.vpc_primary.vpc_id
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidrs
      description = "SSH"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All outbound"
    }
  ]
}
module "sg_bastion_dr" {
  source = "./modules/sg"
  providers = {
    aws = aws.dr
  }
  name   = "dr"
  type   = "bastion"
  vpc_id = module.vpc_dr.vpc_id
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidrs
      description = "SSH"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All outbound"
    }
  ]
}

module "sg_nginx_primary" {
  source = "./modules/sg"
  providers = {
    aws = aws.primary
  }
  name   = "primary"
  type   = "nginx"
  vpc_id = module.vpc_primary.vpc_id
  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.allowed_nginx_cidrs
      description = "HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = var.allowed_nginx_cidrs
      description = "HTTPS"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All outbound"
    }
  ]
}
module "sg_nginx_dr" {
  source = "./modules/sg"
  providers = {
    aws = aws.dr
  }
  name   = "dr"
  type   = "nginx"
  vpc_id = module.vpc_dr.vpc_id
  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.allowed_nginx_cidrs
      description = "HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = var.allowed_nginx_cidrs
      description = "HTTPS"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All outbound"
    }
  ]
}

module "sg_rds_primary" {
  source = "./modules/sg"
  providers = {
    aws = aws.primary
  }
  name   = "primary"
  type   = "rds"
  vpc_id = module.vpc_primary.vpc_id
  ingress_rules = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = var.allowed_db_cidrs
      description = "DB access"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All outbound"
    }
  ]
}
module "sg_rds_dr" {
  source    = "./modules/sg"
  providers = { aws = aws.dr }
  name      = "dr"
  type      = "rds"
  vpc_id    = module.vpc_dr.vpc_id
  ingress_rules = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = var.allowed_db_cidrs
      description = "DB access"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All outbound"
    }
  ]
}

module "rds_primary" {
  source                 = "./modules/rds"
  providers              = { aws = aws.primary }
  name                   = "primary"
  subnet_ids             = module.vpc_primary.db_subnet_ids
  vpc_security_group_ids = [module.sg_rds_primary.sg_id]
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.db_password
  engine_version         = var.db_engine_version
  multi_az               = true
  monitoring_role_arn    = module.rds_mysql_role.role_arn

}
module "rds_dr" {
  source                 = "./modules/rds"
  providers              = { aws = aws.dr }
  name                   = "dr"
  subnet_ids             = module.vpc_dr.db_subnet_ids
  vpc_security_group_ids = [module.sg_rds_dr.sg_id]
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.db_password
  engine_version         = var.db_engine_version
  multi_az               = true
  monitoring_role_arn    = module.rds_mysql_role_dr.role_arn
}



module "eks_primary" {
  source                = "./modules/eks"
  providers             = { aws = aws.primary }
  cluster_name          = "eks-primary"
  cluster_version       = var.eks_cluster_version
  subnet_ids            = module.vpc_primary.private_subnet_ids
  vpc_id                = module.vpc_primary.vpc_id
  node_instance_type    = var.eks_node_instance_type
  node_count            = var.eks_node_count
  cluster_ingress_cidrs = var.eks_api_cidrs
  eks_cluster_role      = module.eks_cluster_role.role_arn
  eks_node_role         = module.eks_node_group_role.role_arn
}

module "eks_dr" {
  source                = "./modules/eks"
  providers             = { aws = aws.dr }
  cluster_name          = "eks-dr"
  cluster_version       = var.eks_cluster_version
  subnet_ids            = module.vpc_dr.private_subnet_ids
  vpc_id                = module.vpc_dr.vpc_id
  node_instance_type    = var.eks_node_instance_type
  node_count            = var.eks_node_count
  cluster_ingress_cidrs = var.eks_api_cidrs
  eks_cluster_role      = module.eks_cluster_role.role_arn
  eks_node_role         = module.eks_node_group_role.role_arn
}

module "sg_infra_primary" {
  source = "./modules/sg"
  providers = {
    aws = aws.primary
  }
  name   = "infra"
  type   = "infra"
  vpc_id = module.vpc_primary.vpc_id

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidrs
      description = "Allow SSH"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = var.allowed_http_cidrs
      description = "Allow port 8080"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]
}

module "nginx_ec2_primary" {
  source                      = "./modules/ec2"
  providers                   = { aws = aws.primary }
  name                        = var.nginx_name
  type                        = var.nginx_type
  instance_count              = var.nginx_instance_count
  ami_id                      = var.nginx_ami_primary
  instance_type               = var.nginx_instance_type
  key_name                    = var.key_name
  subnet_ids                  = module.vpc_primary.private_subnet_ids
  sg_id                       = module.sg_nginx_primary.sg_id
  associate_public_ip_address = var.nginx_associate_public_ip
  root_volume_size            = var.root_volume_size
}

module "bastion_ec2_primary" {
  source                      = "./modules/ec2"
  providers                   = { aws = aws.primary }
  name                        = var.bastion_name
  type                        = var.bastion_type
  instance_count              = var.bastion_instance_count
  ami_id                      = var.bastion_ami_primary
  instance_type               = var.bastion_instance_type
  key_name                    = var.key_name
  subnet_ids                  = module.vpc_primary.public_subnet_ids
  sg_id                       = module.sg_bastion_primary.sg_id
  associate_public_ip_address = var.bastion_associate_public_ip
  root_volume_size            = var.root_volume_size
}

module "infra_ec2_primary" {
  source                      = "./modules/ec2"
  providers                   = { aws = aws.primary }
  name                        = var.infra_name
  type                        = var.infra_type
  instance_count              = var.infra_instance_count
  ami_id                      = var.infra_ami_primary
  instance_type               = var.infra_instance_type
  key_name                    = var.key_name
  subnet_ids                  = module.vpc_primary.private_subnet_ids
  sg_id                       = module.sg_infra_primary.sg_id
  associate_public_ip_address = var.infra_associate_public_ip
  root_volume_size            = var.root_volume_size
}

module "bastion_ec2_dr" {
  source                      = "./modules/ec2"
  providers                   = { aws = aws.dr }
  name                        = var.bastion_name
  type                        = var.bastion_type
  instance_count              = var.bastion_instance_count
  ami_id                      = var.bastion_ami_dr
  instance_type               = var.bastion_instance_type
  key_name                    = var.key_name
  subnet_ids                  = module.vpc_dr.private_subnet_ids
  sg_id                       = module.sg_bastion_dr.sg_id
  associate_public_ip_address = true
  root_volume_size            = var.root_volume_size
}
module "nginx_ec2_dr" {
  source                      = "./modules/ec2"
  providers                   = { aws = aws.dr }
  name                        = var.nginx_name
  type                        = var.nginx_type
  instance_count              = var.nginx_instance_count
  ami_id                      = var.nginx_ami_dr
  instance_type               = var.nginx_instance_type
  key_name                    = var.key_name
  subnet_ids                  = module.vpc_dr.private_subnet_ids
  sg_id                       = module.sg_nginx_dr.sg_id
  associate_public_ip_address = false
  root_volume_size            = var.root_volume_size
}

module "RDS_db_secret" {
  source      = "./modules/SecretsManager"
  secret_name = "rds-secret"
  description = "RDS credentials secret"
  username    = var.db_username # Provide this variable
}


module "ecr_frontend" {
  source                   = "./modules/ecr"
  name                     = var.ecr_frontend_name
  image_tag_mutability     = var.ecr_image_tag_mutability
  scan_on_push             = var.ecr_scan_on_push
  tags                     = var.ecr_frontend_tags
  replication_destinations = var.ecr_frontend_replication_destinations
}

module "ecr_backend" {
  source                   = "./modules/ecr"
  name                     = var.ecr_backend_name
  image_tag_mutability     = var.ecr_image_tag_mutability
  scan_on_push             = var.ecr_scan_on_push
  tags                     = var.ecr_backend_tags
  replication_destinations = var.ecr_backend_replication_destinations
}

module "eks_cluster_role" {
  source      = "./modules/iam"
  iam_role    = var.eks_cluster_role_name
  aws_service = var.eks_cluster_trusted_services
  policy_arns = var.eks_cluster_policy_arns
}

module "eks_node_group_role" {
  source      = "./modules/iam"
  iam_role    = var.eks_node_group_role_name
  aws_service = var.eks_node_group_trusted_services
  policy_arns = var.eks_node_group_policy_arns
}

module "rds_mysql_role" {
  source = "./modules/iam"
  providers = {
    aws = aws.primary
  }
  iam_role    = var.rds_mysql_role_name
  aws_service = var.rds_mysql_aws_services
  policy_arns = var.rds_mysql_policy_arns
}
module "rds_mysql_role_dr" {
  source      = "./modules/iam"
  providers   = { aws = aws.dr }
  iam_role    = var.rds_mysql_role_name
  aws_service = var.rds_mysql_aws_services
  policy_arns = var.rds_mysql_policy_arns
}
