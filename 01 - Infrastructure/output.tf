output "public_ip" {
  value = "${aws_eip.elastic_ip_for_nat_gw.public_ip}"
}
