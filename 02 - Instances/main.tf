
resource "aws_security_group" "kubernetes_security_group" {
  name        = "${var.name_prefix}-Kubernetes-SG"
  description = "Kube pipe to pods"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "pod_security_group" {
  name        = "${var.name_prefix}-Pod-SG"
  description = "Pods pipe to Kubernetes"
  vpc_id      = "${var.vpc_id}"
  tags = {
    Name                            = "${var.name_prefix}-Pod-SG"
    "${var.kubernetes_cluster_key}" = "${var.kubernetes_cluster_value}"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "kubernetes-pod-https" {
  description              = "Pod pipe to Kubernetes"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.kubernetes_security_group.id}"
  source_security_group_id = "${aws_security_group.pod_security_group.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "pod-to-pod" {
  description              = "Pod pipe to Pods"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.pod_security_group.id}"
  source_security_group_id = "${aws_security_group.pod_security_group.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "kubernetes-to-pod" {
  description              = "Kubernetes pipe to Pods"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.pod_security_group.id}"
  source_security_group_id = "${aws_security_group.kubernetes_security_group.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "internal-kubernetes-https" {
  cidr_blocks       = ["${var.local_cidr}"]
  description       = "Internal pipe to Kubernetes"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.kubernetes_security_group.id}"
  to_port           = 443
  type              = "ingress"
}
