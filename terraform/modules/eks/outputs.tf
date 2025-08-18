output "cluster_id" {
  value = aws_eks_cluster.App.id
}

output "endpoint" {
  value = aws_eks_cluster.App.endpoint
}

output "certificate_authority" {
  value = aws_eks_cluster.App.certificate_authority[0].data
}

output "node_group_1_name" {
  value = aws_eks_node_group.ng1.node_group_name
}

output "node_group_2_name" {
  value = aws_eks_node_group.ng2.node_group_name
}
