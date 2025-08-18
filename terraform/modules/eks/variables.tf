variable "cluster_name" { type = string }
variable "cluster_version" { type = string }
variable "subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }
variable "node_instance_type" { type = string }
variable "node_count" { type = number }
variable "cluster_ingress_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable "eks_cluster_role" {}
variable "eks_node_role" {}


