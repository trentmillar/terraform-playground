locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${module.kubernetes.eks_cluster.endpoint}
    certificate-authority-data: ${module.kubernetes.eks_cluster.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.KUBERNETES_CLUSTER_NAME}"
KUBECONFIG
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}

# Join configuration

locals {
  config-map-aws-auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${module.kubernetes.node_iam_role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}

output "config-map-aws-auth" {
  value = "${local.config-map-aws-auth}"
}

output "user_key_pair" {
  value = "${module.setup.aws_key_pair}"
}

output "public_subnet_ids" {
  value = "${module.vpc.public_subnet_ids}"
}

output "cluster_vpc" {
  value = "${module.vpc.cluster_vpc}"
}
output "kubernetes_security_group" {
  value = "${module.instances.kubernetes_security_group}"
}

output "eks_cluster" {
  value = "${module.kubernetes.eks_cluster}"
}

output "node_iam_role" {
  value = "${module.kubernetes.node_iam_role}"
}