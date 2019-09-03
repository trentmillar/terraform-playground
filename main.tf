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
    public_key_path = ""
}

module "vpc" {
    source = "./01 - Infrastructure"
    key_name = ""
    key_path = ""
    region = "${var.REGION}"
}
