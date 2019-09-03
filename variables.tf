variable "ENVIRONMENT" { }

variable "REGION" {
    default = "us-west-2"
}

variable "PROFILE" {
    default = "default"
}

variable "KEY_NAME" { }

variable "KEY_PUBLIC_PATH" { }

variable "KEY_PRIVATE_PATH" { }

variable "VPC_CIDR" {
    default = "10.0.0.0/16"
}

variable "PUBLIC_SUBNET_A_CIDR" {
    default = "10.0.1.0/24"
}

variable "PRIVATE_SUBNET_A_CIDR" {
    default = "10.0.4.0/24"
}

variable "PUBLIC_SUBNET_B_CIDR" {
    default = "10.0.2.0/24"
}

variable "PRIVATE_SUBNET_B_CIDR" {
    default = "10.0.5.0/24"
}

variable "PUBLIC_SUBNET_C_CIDR" {
    default = "10.0.3.0/24"
}

variable "PRIVATE_SUBNET_C_CIDR" {
    default = "10.0.6.0/24"
}

variable "KUBERNETES_CLUSTER_KEY" { }

variable "KUBERNETES_CLUSTER_VALUE" { }

variable "KUBERNETES_ELB_INTERNAL_KEY" { }

variable "KUBERNETES_ELB_INTERNAL_VALUE" { }

variable "KUBERNETES_ELB_KEY" { }

variable "KUBERNETES_ELB_VALUE" { }