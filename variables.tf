variable "cluster_name" {
  default = "ec2-cloudwatch-test"
}

variable "region" {
  default = "us-east-1"
}

variable availability_zones {
  type    = "list"
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e"]
}

#VPC module input variables
variable vpc_name {
  default = "tf-vpc-cloudwatch"
}

variable cidr {
  default = "10.30.0.0/16"
}

variable env_cidr {
  default = "10.0.0.0/8"
}

variable ssh_key_name {
  default = "kwame-test"
}

variable public_subnets {
  default = ["10.30.1.0/24", "10.30.2.0/24", "10.30.3.0/24", "10.30.4.0/24", "10.30.5.0/24"]
}

variable enable_dns_support {
  default = "true"
}

variable map_public_ip_on_launch {
  default = "true"
}

variable enable_dns_hostnames {
  default = "true"
}

variable enable_nat_gateway {
  default = "false"
}

variable "environment" {
  default = "ansible-deployment"
}

variable "ansible_node_instance_size" {
  default = "t2.micro"
}

#Ubuntu 16.04
variable "ami" {
  default = "ami-759bc50a"
}

#Amazon Linux AMI 2017.03.1.20170623 x86_64 HVM GP2
variable "ansible_node_ami" {
  default = "ami-b70554c8"
}

variable "state_s3_bucket" {
  default = "terraform-ansible-informatux"
}

#Space separated emails addresses
variable "critical_alerts_notification" {
  default = "daniel.bahena@gmail.com"
}

#Space separated emails addresses
variable "non_critical_alerts" {
  default = "daniel.bahena@gmail.com kwame@informatux.net"
}
