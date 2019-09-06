output "public_subnet_ids" {
  value = ["${aws_subnet.public_subnet_aza.id}", "${aws_subnet.public_subnet_azb.id}", "${aws_subnet.public_subnet_azc.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private_subnet_aza.id}", "${aws_subnet.private_subnet_azb.id}", "${aws_subnet.private_subnet_azc.id}"]
}

output "cluster_vpc" {
  value = "${aws_vpc.cluster_vpc}"
}
