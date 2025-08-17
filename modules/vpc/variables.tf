variable "vpc_cidr" {}
variable "vpc_name" {}
variable "azs" { type = list(string) }
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }
variable "db_subnet_cidrs" { type = list(string) }
variable "nat_gw_subnet_indexes" { type = list(number) }