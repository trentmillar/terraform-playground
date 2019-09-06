variable "name_prefix" { }

variable "key_name" { }


variable "eks_cluster" { }

variable "kubernetes_cluster_name" { }

variable "kubernetes_cluster_key" { }

variable "kubernetes_cluster_value" {
  default = "owned"
}

variable "nodes_iam_instance_profile" { }

variable "nodes_security_group" { }

variable "public_subnet_ids" {
  type = "list"
}

variable "aws_ami_owner" {
  default = "602401143452"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "eks_node_max_size" {
  default = 3
}

variable "eks_node_min_size" {
  default = 1
}

variable "eks_node_desired_size" {
  default = 2
}