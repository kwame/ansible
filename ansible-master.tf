resource "aws_instance" "ansible_master_node" {
  ami                         = "${var.ansible_node_ami}"
  instance_type               = "${var.ansible_node_instance_size}"
  key_name                    = "${var.ssh_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.ansible_master_node.id}"]
  subnet_id                   = "${module.vpc.public_subnets[0]}"
  user_data                   = "${file("files/ansible_node.sh")}"
  iam_instance_profile        = "${aws_iam_instance_profile.ansible_node-profile.id}"
  associate_public_ip_address = true
  source_dest_check           = false

  #lifecycle {
  #  ignore_changes = ["user_data"]
  #}

  tags {
    Name          = "EC2 cloudwatch test"
    "Terraform"   = "true"
    "Environment" = "${var.environment}"
  }
}

resource "aws_security_group" "ansible_master_node" {
  name   = "${var.cluster_name}-ansible_node-test-SG"
  vpc_id = "${module.vpc.vpc_id}"

  tags = {
    "Terraform"   = "true"
    "Role"        = "Ops Utility security group"
    "Environment" = "${var.cluster_name}"
    "Name"        = "${var.cluster_name}-ansible_node-test-SG"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_server_ansible_node_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.ansible_master_node.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_server_ansible_node_outbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.ansible_master_node.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
