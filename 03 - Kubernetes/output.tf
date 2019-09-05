output "eks_cluster" {
  value = "${aws_eks_cluster.eks_cluster}"
}

output "node_iam_role" {
    value = "${aws_iam_role.node_role}"
}

output "nodes_iam_instance_profile" {
    value = "${aws_iam_instance_profile.nodes_iam_instance_profile}"
}