data "aws_ami" "eks_node_ami" {
  most_recent = true
  owners = ["${var.aws_ami_owner}"]
  
  filter {
    name = "name"
    values = ["amazon-eks-node-${var.eks_cluster.version}-*"]
  }

  filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_launch_configuration" "eks_node" {
  image_id                    = "${data.aws_ami.eks_node_ami.id}"
  instance_type               = "${var.ec2_instance_type}"
  associate_public_ip_address = true
  name_prefix                 = "${var.name_prefix}_eks_node"
  iam_instance_profile        = "${var.nodes_iam_instance_profile.name}"
  security_groups             = ["${var.nodes_security_group.id}"]

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<EOF
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${var.eks_cluster.endpoint}' --b64-cluster-ca '${var.eks_cluster.certificate_authority.0.data}' '${var.kubernetes_cluster_name}'
EOF
}

resource "aws_autoscaling_group" "eks_node" {
  launch_configuration = "${aws_launch_configuration.eks_node.id}"
  name = "${var.name_prefix}-EKS-Node"
  vpc_zone_identifier = "${var.public_subnet_ids}"
  min_size = "${var.eks_node_min_size}"
  max_size = "${var.eks_node_max_size}"
  desired_capacity = "${var.eks_node_desired_size}"
  
  tag {
    key = "${var.kubernetes_cluster_key}"
    value = "${var.kubernetes_cluster_value}"
    propagate_at_launch = true
  }
}