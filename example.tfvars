ENVIRONMENT = "TEST"

REGION = "us-west-2"
PROFILE = "default"
REMOTE_STATE_BUCKET = "terraform-state"
REMOTE_STATE_KEY = "playground.tfstate"
 
VPC_CIDR = "10.0.0.0/16"
PUBLIC_SUBNET_A_CIDR = "10.0.1.0/24"
PUBLIC_SUBNET_B_CIDR = "10.0.2.0/24"
PUBLIC_SUBNET_C_CIDR = "10.0.3.0/24"
PRIVATE_SUBNET_A_CIDR = "10.0.4.0/24"
PRIVATE_SUBNET_B_CIDR = "10.0.5.0/24"
PRIVATE_SUBNET_C_CIDR = "10.0.6.0/24"
USERS_LOCAL_CIDR = "0.0.0.0/0"

KEY_NAME = "mypair"
KEY_PUBLIC_PATH = "./keypair/mypair.pub"
KEY_PRIVATE_PATH = "./keypair/mypair"

KUBERNETES_CLUSTER_NAME = "cluster1"
KUBERNETES_CLUSTER_KEY = "kubernetes.io/cluster/cluster1"
KUBERNETES_CLUSTER_VALUE = "shared"
KUBERNETES_ELB_INTERNAL_KEY = "kubernetes.io/role/internal-elb"
KUBERNETES_ELB_INTERNAL_VALUE = "1"
KUBERNETES_ELB_KEY = "kubernetes.io/role/elb"
KUBERNETES_ELB_VALUE = "1"