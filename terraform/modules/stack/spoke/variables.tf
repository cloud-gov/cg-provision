variable "stack_description" {
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "az1" {
  default = "us-gov-west-1a"
}

variable "az2" {
  default = "us-gov-west-1b"
}

variable "aws_default_region" {
  default = "us-gov-west-1"
}

variable "public_cidr_1" {
  default = "10.0.100.0/24"
}

variable "public_cidr_2" {
  default = "10.0.101.0/24"
}

variable "private_cidr_1" {
}

variable "private_cidr_2" {
}

variable "nat_gateway_instance_type" {
  default = "c3.2xlarge"
}

variable "rds_private_cidr_1" {
}

variable "rds_private_cidr_2" {
}

variable "rds_instance_type" {
  default = "db.m4.large"
}

variable "rds_db_size" {
  default = 20
}

variable "rds_allow_major_version_upgrade" {
  default = "false"
}

variable "rds_apply_immediately" {
  default = "false"
}

variable "rds_db_name" {
  default = "bosh"
}

variable "rds_db_engine" {
  default = "postgres"
}

variable "rds_db_engine_version" {
  default = "12.8"
}

variable "rds_parameter_group_family" {
  default = "postgres12"
}

variable "rds_username" {
  default = "bosh"
}

variable "restricted_ingress_web_cidrs" {
  type    = list(string)
  default = ["127.0.0.1/32", "192.168.0.1/24"]
}

variable "restricted_ingress_web_ipv6_cidrs" {
  type    = list(string)
  default = []
}

variable "aws_partition" {
}

variable "rds_password" {
}

variable "credhub_rds_password" {
}

variable "account_id" {
}

variable "target_vpc_id" {
}

variable "target_vpc_cidr" {
}

variable "target_bosh_security_group" {
}

variable "target_az1_route_table" {
}

variable "target_az2_route_table" {
}

variable "target_monitoring_security_groups" {
  type    = list(string)
  default = []
}

variable "target_concourse_security_groups" {
  type    = list(string)
  default = []
}

variable "target_credhub_security_groups" {
  type    = list(string)
  default = []
}
