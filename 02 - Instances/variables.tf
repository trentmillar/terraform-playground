variable "name_prefix" { }

variable "vpc_id" { }

variable "local_cidr" { }

variable "kubernetes_cluster_key" { }

variable "kubernetes_cluster_value" {
  default = "owned"
}

variable "public_subnet_ids" { }

variable "private_subnet_ids" { }
