output "eks_cluster" {
  value = "${aws_eks_cluster.eks_cluster}"
}

output "node_iam_role" {
    value = "${aws_iam_role.node_role}"
}