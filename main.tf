provider "aws" {
    region = "${var.REGION}"
    profile = "${var.PROFILE}"
}

terraform {
    backend "s3" { }
}

module "setup" {
    source = "./00 - Setup"
    key_name = ""
    key_path = ""
}
output "user_key_pair" {
  value = "${module.setup.aws_key_pair}"
}
module "vpc" {
    source = "./01 - Infrastructure"
    key_name = ""
    key_path = ""
    region = "${var.REGION}"
}

