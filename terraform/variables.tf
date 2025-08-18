variable "primary_region" {}
variable "dr_region" {}


variable "primary_vpc_cidr" {}
variable "primary_vpc_name" {}
variable "primary_azs" { type = list(string) }
variable "primary_public_subnet_cidrs" { type = list(string) }
variable "primary_private_subnet_cidrs" { type = list(string) }
variable "primary_db_subnet_cidrs" { type = list(string) }
variable "primary_nat_gw_subnet_indexes" { type = list(number) }

variable "dr_vpc_cidr" {}
variable "dr_vpc_name" {}
variable "dr_azs" { type = list(string) }
variable "dr_public_subnet_cidrs" { type = list(string) }
variable "dr_private_subnet_cidrs" { type = list(string) }
variable "dr_db_subnet_cidrs" { type = list(string) }
variable "dr_nat_gw_subnet_indexes" { type = list(number) }

variable "allowed_ssh_cidrs" { type = list(string) }
variable "allowed_nginx_cidrs" { type = list(string) }
variable "allowed_db_cidrs" { type = list(string) }

variable "db_instance_class" {}
variable "db_username" {}
variable "db_password" { sensitive = true }
variable "db_engine_version" {}
variable "name" {}


variable "eks_cluster_version" {}
variable "eks_node_instance_type" {}
variable "eks_node_count" {}
variable "eks_api_cidrs" {}

variable "allowed_http_cidrs" {}

variable "key_name" {
  description = "SSH key name for EC2"
  type        = string
}

variable "nginx_name" { type = string }
variable "nginx_type" { type = string }
variable "nginx_instance_count" { type = number }
variable "nginx_ami_primary" { type = string }
variable "nginx_ami_dr" { type = string }
variable "nginx_instance_type" { type = string }
variable "nginx_associate_public_ip" { type = bool }


variable "bastion_name" { type = string }
variable "bastion_type" { type = string }
variable "bastion_instance_count" { type = number }
variable "bastion_ami_primary" { type = string }
variable "bastion_ami_dr" { type = string }
variable "bastion_instance_type" { type = string }
variable "bastion_associate_public_ip" { type = bool }


variable "infra_name" { type = string }
variable "infra_type" { type = string }
variable "infra_instance_count" { type = number }
variable "infra_ami_primary" { type = string }
variable "infra_instance_type" { type = string }
variable "infra_associate_public_ip" { type = bool }

variable "secret_name" {
  description = "Base name for the secret (random suffix will be added)"
  type        = string
}

variable "description" {
  description = "Description for the secret"
  type        = string
}

variable "username" {
  description = "Database username to store in the secret"
  type        = string
}


variable "replication_destinations" {
  description = "List of replication destinations with region and registry ID"
  type = list(object({
    region      = string
    registry_id = string
  }))
  default = []
}
variable "ecr_frontend_name" {
  description = "Name for frontend ECR repo"
  type        = string
}

variable "ecr_backend_name" {
  description = "Name for backend ECR repo"
  type        = string
}

variable "ecr_image_tag_mutability" {
  description = "ECR image tag mutability"
  type        = string
  default     = "MUTABLE"
}

variable "ecr_scan_on_push" {
  description = "Enable image scan on push"
  type        = bool
  default     = true
}

variable "ecr_frontend_tags" {
  description = "Tags for frontend ECR"
  type        = map(string)
  default     = {}
}

variable "ecr_backend_tags" {
  description = "Tags for backend ECR"
  type        = map(string)
  default     = {}
}

variable "ecr_frontend_replication_destinations" {
  description = "List of replication destinations for frontend ECR"
  type = list(object({
    region      = string
    registry_id = string
  }))
  default = []
}

variable "ecr_backend_replication_destinations" {
  description = "List of replication destinations for backend ECR"
  type = list(object({
    region      = string
    registry_id = string
  }))
  default = []
}


variable "root_volume_size" {}

variable "eks_cluster_role_name" {

}
variable "eks_cluster_trusted_services" {

}
variable "eks_cluster_policy_arns" {

}
variable "eks_node_group_role_name" {

}
variable "eks_node_group_trusted_services" {

}
variable "eks_node_group_policy_arns" {

}

variable "rds_mysql_role_name" {

}
variable "rds_mysql_aws_services" {

}
variable "rds_mysql_policy_arns" {

}
