resource "aws_vpc" "cluster_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = {
    Name                            = "${var.name_prefix}-VPC"
    "${var.kubernetes_cluster_key}" = "${var.kubernetes_cluster_value}"
    BackupDaily                     = true
  }
}

/* Kubernetes cluster subnets */
resource "aws_subnet" "public_subnet_aza" {
  cidr_block              = "${var.public_subnet_a_cidr}"
  vpc_id                  = "${aws_vpc.cluster_vpc.id}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name                            = "${var.name_prefix}-Public-Subnet-AZ_A"
    "${var.kubernetes_cluster_key}" = "${var.kubernetes_cluster_value}"
    "${var.kubernetes_elb_key}"     = "${var.kubernetes_elb_value}"
    BackupDaily                     = true
  }
}

resource "aws_subnet" "public_subnet_azb" {
  cidr_block              = "${var.public_subnet_b_cidr}"
  vpc_id                  = "${aws_vpc.cluster_vpc.id}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = {
    Name                            = "${var.name_prefix}-Public-Subnet-AZ_B"
    "${var.kubernetes_cluster_key}" = "${var.kubernetes_cluster_value}"
    BackupDaily                     = true
  }
}

resource "aws_subnet" "public_subnet_azc" {
  cidr_block              = "${var.public_subnet_c_cidr}"
  vpc_id                  = "${aws_vpc.cluster_vpc.id}"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}c"
  tags = {
    Name                            = "${var.name_prefix}-Public-Subnet-AZ_C"
    "${var.kubernetes_cluster_key}" = "${var.kubernetes_cluster_value}"
    BackupDaily                     = true
  }
}

resource "aws_subnet" "private_subnet_aza" {
  cidr_block        = "${var.private_subnet_a_cidr}"
  vpc_id            = "${aws_vpc.cluster_vpc.id}"
  availability_zone = "${var.region}a"
  tags = {
    Name                                 = "${var.name_prefix}-Private-Subnet-AZ_A"
    "${var.kubernetes_cluster_key}"      = "${var.kubernetes_cluster_value}"
    "${var.kubernetes_elb_internal_key}" = "${var.kubernetes_elb_internal_value}"
    BackupDaily                          = true
  }
}

resource "aws_subnet" "private_subnet_azb" {
  cidr_block        = "${var.private_subnet_b_cidr}"
  vpc_id            = "${aws_vpc.cluster_vpc.id}"
  availability_zone = "${var.region}b"
  tags = {
    Name                            = "${var.name_prefix}-Private-Subnet-AZ_B"
    "${var.kubernetes_cluster_key}" = "${var.kubernetes_cluster_value}"
    BackupDaily                     = true
  }
}

resource "aws_subnet" "private_subnet_azc" {
  cidr_block        = "${var.private_subnet_c_cidr}"
  vpc_id            = "${aws_vpc.cluster_vpc.id}"
  availability_zone = "${var.region}c"
  tags = {
    Name                            = "${var.name_prefix}-Private-Subnet-AZ_C"
    "${var.kubernetes_cluster_key}" = "${var.kubernetes_cluster_value}"
    BackupDaily                     = true
  }
}

resource "aws_internet_gateway" "cluster" {
  vpc_id = "${aws_vpc.cluster_vpc.id}"

  tags = {
    Name        = "${var.name_prefix}-IG"
    BackupDaily = true

  }
}

// Route tables
resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.cluster_vpc.id}"
  tags = {
    Name        = "${var.name_prefix}-Public-Route-Table"
    BackupDaily = true
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.cluster.id}"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.cluster_vpc.id}"
  tags = {
    Name        = "${var.name_prefix}-Private-Route-Table"
    BackupDaily = true

  }
}

// Route table associations
resource "aws_route_table_association" "public_route_table-a-association" {
  route_table_id = "${aws_route_table.public_route_table.id}"
  subnet_id      = "${aws_subnet.public_subnet_aza.id}"
}

resource "aws_route_table_association" "public_route_table-b-association" {
  route_table_id = "${aws_route_table.public_route_table.id}"
  subnet_id      = "${aws_subnet.public_subnet_azb.id}"
}

resource "aws_route_table_association" "public_route_table-c-association" {
  route_table_id = "${aws_route_table.public_route_table.id}"
  subnet_id      = "${aws_subnet.public_subnet_azc.id}"
}

resource "aws_route_table_association" "private_route_table-a-association" {
  route_table_id = "${aws_route_table.private_route_table.id}"
  subnet_id      = "${aws_subnet.private_subnet_aza.id}"
}

resource "aws_route_table_association" "private_route_table-b-association" {
  route_table_id = "${aws_route_table.private_route_table.id}"
  subnet_id      = "${aws_subnet.private_subnet_azb.id}"
}

resource "aws_route_table_association" "private_route_table-c-association" {
  route_table_id = "${aws_route_table.private_route_table.id}"
  subnet_id      = "${aws_subnet.private_subnet_azc.id}"
}

// EIP
resource "aws_eip" "elastic_ip_for_nat_gw" {
  vpc = true
  # associate_with_private_ip = "10.0.0.5"
  tags = {
    Name        = "${var.name_prefix}-EIP"
    BackupDaily = true
  }
}

// NAT Gateway - just first subnets
/* resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.elastic_ip_for_nat_gw.id}"
  subnet_id     = "${aws_subnet.public_subnet_aza.id}"
  tags = {
    Name = "${var.name_prefix}-NAT-DW"
  }
  depends_on = ["aws_eip.elastic_ip_for_nat_gw"]
}

resource "aws_route" "nat_gw_route" {
  route_table_id         = "${aws_route_table.private_route_table.id}"
  nat_gateway_id         = "${aws_nat_gateway.nat_gw.id}"
  destination_cidr_block = "0.0.0.0/0"
} */
