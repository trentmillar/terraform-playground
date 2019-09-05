output "kubernetes_security_group" {
  value = "${aws_security_group.kubernetes_security_group}"
}

output "nodes_security_group" {
  value = "${aws_security_group.node_security_group}"
}
