
resource "aws_security_group" "kubernetes_security_group" {
  name        = "${var.name_prefix}-Kubernetes-SG"
  description = "Kube pipe to nodes"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-Kubernetes-SG"
  }
}

resource "aws_security_group" "node_security_group" {
  name        = "${var.name_prefix}-Node-SG"
  description = "Nodes pipe to Kubernetes"
  vpc_id      = "${var.vpc_id}"
  tags = {
    Name                            = "${var.name_prefix}-Node-SG"
    "${var.kubernetes_cluster_key}" = "${var.kubernetes_cluster_value}"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  //todo, remove ... exposes all services running on the nodes.
  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  /* ingress {
    from_port = 22
    protocol  = "TCP"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  } */
}

resource "aws_security_group" "elb_security_group" {
  name        = "${var.name_prefix}-ELB-SG"
  description = "ELB Security Group"
  vpc_id      = "${var.vpc_id}"


  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow web traffic to LB"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "kubernetes_nodes_https" {
  description              = "Nodes pipe to Kubernetes"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.kubernetes_security_group.id}"
  source_security_group_id = "${aws_security_group.node_security_group.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "node_to_node" {
  description              = "Nodes pipe to Nodes"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.node_security_group.id}"
  source_security_group_id = "${aws_security_group.node_security_group.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "kubernetes_to_nodes" {
  description              = "Kubernetes pipe to Nodes"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.node_security_group.id}"
  source_security_group_id = "${aws_security_group.kubernetes_security_group.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "internal_kubernetes_https" {
  cidr_blocks       = ["${var.local_cidr}"]
  description       = "Internal pipe to Kubernetes"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.kubernetes_security_group.id}"
  to_port           = 443
  type              = "ingress"
}

resource "aws_elb" "cluster_load_balancer" {
  name            = "${var.name_prefix}-Public-LoadBalancer"
  internal        = false
  security_groups = ["${aws_security_group.elb_security_group.id}"]
  subnets         = "${var.public_subnet_ids}"

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  /* health_check {
      healthy_threshold   = 5
      interval            = 30
      target              = "HTTP:80/index.html"
      timeout             = 10
      unhealthy_threshold = 5
  } */
}

resource "aws_elb" "backend_load_balancer" {
  name            = "${var.name_prefix}-Private-LoadBalance"
  internal        = true
  security_groups = ["${aws_security_group.elb_security_group.id}"]
  subnets         = "${var.private_subnet_ids}"

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  /* health_check {
      healthy_threshold   = 5
      interval            = 30
      target              = "HTTP:80/index.html"
      timeout             = 10
      unhealthy_threshold = 5
  } */
}

// just for aws-backup testing
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "back_me_up" {
  subnet_id     = "${var.public_subnet_ids[0]}"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"

  tags = {
    backup-policy = "daily"
  }
}

resource "aws_ebs_volume" "back_me_up_ebs_volume" {
  availability_zone = "us-west-2a"
  size              = 10

  tags = {
    backup-policy = "daily"
  }
}

resource "aws_volume_attachment" "back_me_up_ebs_volume_attachment" {
  device_name = "/dev/sdd"
  volume_id   = "${aws_ebs_volume.back_me_up_ebs_volume.id}"
  instance_id = "${aws_instance.back_me_up.id}"


}
