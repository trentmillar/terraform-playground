resource "aws_iam_role" "kubernetes_role" {
  name = "${var.name_prefix}-Kubernetes-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "node_role" {
  name = "${var.name_prefix}-Node-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

/* Node specifics */
resource "aws_iam_role_policy_attachment" "nodes_AwsEksWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.node_role.name}"
}

resource "aws_iam_role_policy_attachment" "nodes_AwsEksCniPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.node_role.name}"
}

resource "aws_iam_role_policy_attachment" "nodes_AwsEc2ContainerRegistryReadOnlyPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.node_role.name}"
}

resource "aws_iam_instance_profile" "nodes_iam_instance_profile" {
  name = "${var.name_prefix}-Nodes-Profile"
  role = "${aws_iam_role.node_role.name}"
}

/* Cluster specifics */
resource "aws_iam_role_policy_attachment" "kubernetes_AwsEksClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.kubernetes_role.name}"
}

resource "aws_iam_role_policy_attachment" "kubernetes_AwsEksServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.kubernetes_role.name}"
}

resource "aws_iam_role_policy" "kubernetes_service_policy" {
  name = "service-linked-role"
  role = "${aws_iam_role.kubernetes_role.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "arn:aws:iam::*:role/aws-service-role/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAccountAttributes"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.kubernetes_cluster_name}"
  role_arn = "${aws_iam_role.kubernetes_role.arn}"

  vpc_config {
    security_group_ids = ["${var.kubernetes_security_group.id}"]
    subnet_ids         = "${var.public_subnet_ids}"
  }

  depends_on = [
    "aws_iam_role_policy_attachment.kubernetes_AwsEksClusterPolicy",
    "aws_iam_role_policy_attachment.kubernetes_AwsEksServicePolicy",
  ]
}