resource "aws_key_pair" "user_key" {
  key_name = "${var.key_name}"
  public_key = "${file("${var.key_public_path}")}"
}
