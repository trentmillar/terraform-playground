output "public_ip" {
  value = "${aws_eip.elastic_ip_for_nat_gw.public_ip}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public_subnet_aza.id}", "${aws_subnet.public_subnet_azb.id}", "${aws_subnet.public_subnet_azc.id}"]
}

output "cluster_vpc" {
  value = "${aws_vpc.cluster_vpc}"
}
