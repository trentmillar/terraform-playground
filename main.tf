provider "aws" {
  region  = "${var.REGION}"
  profile = "${var.PROFILE}"
}

provider "http" {}

terraform {
  backend "s3" {}
}

# data "terraform_remote_state" "network_configuration" {
#     backend = "s3"
#     config = {
#         bucket = "${var.REMOTE_STATE_BUCKET}"
#         key = "${var.REMOTE_STATE_KEY}"
#         region = "${var.REGION}"
#     }
# }

module "setup" {
  source          = "./00 - Setup"
  key_name        = "${var.KEY_NAME}"
  key_public_path = "${var.KEY_PUBLIC_PATH}"
}

module "vpc" {
  source      = "./01 - Infrastructure"
  name_prefix = "${var.ENVIRONMENT}"
  region      = "${var.REGION}"
  vpc_cidr    = "${var.VPC_CIDR}"
  //availability_zones = ["${slice(data.aws_availability_zones.available.names, 0, 3)}"]
  //private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  //public_subnet_cidr_blocks = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  private_subnet_a_cidr         = "${var.PRIVATE_SUBNET_A_CIDR}"
  public_subnet_a_cidr          = "${var.PUBLIC_SUBNET_A_CIDR}"
  private_subnet_b_cidr         = "${var.PRIVATE_SUBNET_B_CIDR}"
  public_subnet_b_cidr          = "${var.PUBLIC_SUBNET_B_CIDR}"
  private_subnet_c_cidr         = "${var.PRIVATE_SUBNET_C_CIDR}"
  public_subnet_c_cidr          = "${var.PUBLIC_SUBNET_C_CIDR}"
  kubernetes_cluster_key        = "${var.KUBERNETES_CLUSTER_KEY}"
  kubernetes_cluster_value      = "${var.KUBERNETES_CLUSTER_VALUE}"
  kubernetes_elb_key            = "${var.KUBERNETES_ELB_KEY}"
  kubernetes_elb_value          = "${var.KUBERNETES_ELB_VALUE}"
  kubernetes_elb_internal_key   = "${var.KUBERNETES_ELB_INTERNAL_KEY}"
  kubernetes_elb_internal_value = "${var.KUBERNETES_ELB_INTERNAL_VALUE}"
}

module "instances" {
  source                 = "./02 - Instances"
  name_prefix            = "${var.ENVIRONMENT}"
  kubernetes_cluster_key = "${var.KUBERNETES_CLUSTER_KEY}"
  vpc_id                 = "${module.vpc.cluster_vpc.id}"
  local_cidr             = "${var.USERS_LOCAL_CIDR}"
  public_subnet_ids      = "${module.vpc.public_subnet_ids}"
  private_subnet_ids     = "${module.vpc.private_subnet_ids}"
}

module "kubernetes" {
  source                    = "./03 - Kubernetes"
  name_prefix               = "${var.ENVIRONMENT}"
  kubernetes_cluster_name   = "${var.KUBERNETES_CLUSTER_NAME}"
  kubernetes_security_group = "${module.instances.kubernetes_security_group}"
  public_subnet_ids         = "${module.vpc.public_subnet_ids}"
}

module "nodes" {
  source                     = "./04 - Nodes"
  name_prefix                = "${var.ENVIRONMENT}"
  eks_cluster                = "${module.kubernetes.eks_cluster}"
  kubernetes_cluster_name    = "${var.KUBERNETES_CLUSTER_NAME}"
  kubernetes_cluster_key     = "${var.KUBERNETES_CLUSTER_KEY}"
  kubernetes_cluster_value   = "owned"
  nodes_iam_instance_profile = "${module.kubernetes.nodes_iam_instance_profile}"
  nodes_security_group       = "${module.instances.nodes_security_group}"
  public_subnet_ids          = "${module.vpc.public_subnet_ids}"
  key_name                   = "${module.setup.aws_key_pair.key_name}"
}

module "backup" {
  source = "./05 - Backup"
}