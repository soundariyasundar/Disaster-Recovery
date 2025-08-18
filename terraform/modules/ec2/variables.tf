variable "name" { type = string }
variable "type" { type = string }
variable "instance_count" { type = number }
variable "ami_id" { type = string }
variable "instance_type" { type = string }
variable "key_name" { type = string }
variable "subnet_ids" { type = list(string) }
variable "sg_id" { type = string }
variable "associate_public_ip_address" { type = bool }
variable "root_volume_size" {}