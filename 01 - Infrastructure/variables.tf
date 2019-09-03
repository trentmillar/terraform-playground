variable "region" {
  default     = "us-west-2"
  description = "The region of AWS, for AMI lookups."
}

variable "name_prefix" { }

variable "vpc_cidr" { }

variable "private_subnet_a_cidr" { }

variable "public_subnet_a_cidr" { }

variable "private_subnet_b_cidr" { }

variable "public_subnet_b_cidr" { }

variable "private_subnet_c_cidr" { }

variable "public_subnet_c_cidr" { }

variable "kubernetes_cluster_key" { }

variable "kubernetes_cluster_value" { }

variable "kubernetes_elb_key" { }

variable "kubernetes_elb_value" { }

variable "kubernetes_elb_internal_key" { }

variable "kubernetes_elb_internal_value" { }