variable "name" {}
variable "subnet_ids" { type = list(string) }
variable "vpc_security_group_ids" { type = list(string) }
variable "instance_class" { default = "db.t3.medium" }
variable "allocated_storage" { default = 50 }
variable "username" {}
variable "password" {}
variable "engine_version" { default = "8.0" }
variable "multi_az" { default = true }
variable "monitoring_role_arn" {
  
}
