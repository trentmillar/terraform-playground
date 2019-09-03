provider "aws" {
    region = "${var.REGION}"
    profile = "${var.PROFILE}"
}

provider "http" { }

data "aws_region" "current" { }

data "aws_availability_zones" "available" { }

terraform {
    backend "s3" { }
}

module "setup" {
    source = "./00 - Setup"
    key_name = "${var.KEY_NAME}"
    key_public_path = "${var.KEY_PUBLIC_PATH}"
}
output "user_key_pair" {
  value = "${module.setup.aws_key_pair}"
}

module "vpc" {
    source = "./01 - Infrastructure"
    name_prefix = "${var.ENVIRONMENT}"
    region = "${var.REGION}"
    vpc_cidr = "${var.VPC_CIDR}"
    private_subnet_a_cidr = "${var.PRIVATE_SUBNET_A_CIDR}"
    public_subnet_a_cidr = "${var.PUBLIC_SUBNET_A_CIDR}"
    private_subnet_b_cidr = "${var.PRIVATE_SUBNET_B_CIDR}"
    public_subnet_b_cidr = "${var.PUBLIC_SUBNET_B_CIDR}"
    private_subnet_c_cidr = "${var.PRIVATE_SUBNET_C_CIDR}"
    public_subnet_c_cidr = "${var.PUBLIC_SUBNET_C_CIDR}"
    kubernetes_cluster_key = "${var.KUBERNETES_CLUSTER_KEY}"
    kubernetes_cluster_value = "${var.KUBERNETES_CLUSTER_VALUE}"
    kubernetes_elb_key = "${var.KUBERNETES_ELB_KEY}"
    kubernetes_elb_value = "${var.KUBERNETES_ELB_VALUE}"
    kubernetes_elb_internal_key = "${var.KUBERNETES_ELB_INTERNAL_KEY}"
    kubernetes_elb_internal_value = "${var.KUBERNETES_ELB_INTERNAL_VALUE}"
}

