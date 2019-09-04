variable "name_prefix" { }

variable "public_subnet_ids" {
  type = "list"
}

variable "kubernetes_cluster_name" { }

variable "kubernetes_security_group" { }