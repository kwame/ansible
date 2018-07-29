module "vpc" {
  #source = "github.com/terraform-community-modules/tf_aws_vpc"
  source = "github.com/terraform-aws-modules/terraform-aws-vpc"

  name = "${var.vpc_name}"

  cidr           = "${var.cidr}"
  public_subnets = "${var.public_subnets}"

  enable_dns_support      = "${var.enable_dns_support}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
  enable_dns_hostnames    = "${var.enable_dns_hostnames}"
  enable_nat_gateway      = "${var.enable_nat_gateway}"

  azs = ["${var.availability_zones}"]

  tags = {
    "Terraform"   = "true"
    "Environment" = "${var.environment}"
  }
}
