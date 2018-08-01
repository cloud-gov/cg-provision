terraform {
  backend "s3" {}
}

provider "aws" {
  version = "~> 1.12.0"
}

data "terraform_remote_state" "main_vpc" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_bucket}"
    key = "${var.main_stack_name}/terraform.tfstate"
  }
}

data "terraform_remote_state" "tooling_vpc" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_bucket}"
    key = "${var.tooling_stack_name}/terraform.tfstate"
  }
}

data "aws_caller_identity" "current" {}

module "vpc" {
  source = "../../modules/bosh_vpc"

  stack_description = "${var.stack_description}"
  vpc_cidr = "${var.vpc_cidr}"
  public_cidr_1 = "${cidrsubnet(var.vpc_cidr, 8, 100)}"
  public_cidr_2 = "${cidrsubnet(var.vpc_cidr, 8, 101)}"
  private_cidr_1 = "${cidrsubnet(var.vpc_cidr, 8, 1)}"
  private_cidr_2 = "${cidrsubnet(var.vpc_cidr, 8, 2)}"
  restricted_ingress_web_cidrs = []
}

module "vpc_peering" {
  source = "../../modules/vpc_peering"

  peer_owner_id = "${data.aws_caller_identity.current.account_id}"
  target_vpc_id = "${data.terraform_remote_state.main_vpc.vpc_id}"
  target_vpc_cidr = "${data.terraform_remote_state.main_vpc.vpc_cidr}"
  target_az1_route_table = "${data.terraform_remote_state.main_vpc.private_route_table_az1}"
  target_az2_route_table = "${data.terraform_remote_state.main_vpc.private_route_table_az2}"
  source_vpc_id = "${module.vpc.vpc_id}"
  source_vpc_cidr = "${module.vpc.vpc_cidr}"
  source_az1_route_table = "${module.vpc.private_route_table_az1}"
  source_az2_route_table = "${module.vpc.private_route_table_az2}"
}

module "vpc_security_source_to_target" {
  source = "../../modules/vpc_peering_sg"

  target_bosh_security_group = "${data.terraform_remote_state.main_vpc.bosh_security_group}"
  source_vpc_cidr = "${module.vpc.vpc_cidr}"
}

module "vpc_security_target_to_source" {
  source = "../../modules/vpc_peering_sg"

  target_bosh_security_group = "${module.vpc.bosh_security_group}"
  source_vpc_cidr = "${data.terraform_remote_state.main_vpc.vpc_cidr}"
}

module "vpc_peering_tooling" {
  source = "../../modules/vpc_peering"

  peer_owner_id = "${data.aws_caller_identity.current.account_id}"
  target_vpc_id = "${data.terraform_remote_state.tooling_vpc.vpc_id}"
  target_vpc_cidr = "${data.terraform_remote_state.tooling_vpc.vpc_cidr}"
  target_az1_route_table = "${data.terraform_remote_state.tooling_vpc.private_route_table_az1}"
  target_az2_route_table = "${data.terraform_remote_state.tooling_vpc.private_route_table_az2}"
  source_vpc_id = "${module.vpc.vpc_id}"
  source_vpc_cidr = "${module.vpc.vpc_cidr}"
  source_az1_route_table = "${module.vpc.private_route_table_az1}"
  source_az2_route_table = "${module.vpc.private_route_table_az2}"
}

module "vpc_security_source_to_target_tooling" {
  source = "../../modules/vpc_peering_sg"

  target_bosh_security_group = "${data.terraform_remote_state.tooling_vpc.bosh_security_group}"
  source_vpc_cidr = "${module.vpc.vpc_cidr}"
}

module "vpc_security_target_to_source_tooling" {
  source = "../../modules/vpc_peering_sg"

  target_bosh_security_group = "${module.vpc.bosh_security_group}"
  source_vpc_cidr = "${data.terraform_remote_state.tooling_vpc.vpc_cidr}"
}
