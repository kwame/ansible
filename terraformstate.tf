terraform {
  backend "s3" {
    bucket  = "terraform-ansible-informatux"
    key     = "terraform-ansible-informatux/terraform-ansible-cloudwatch.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
