variable "elb_main_cert_id" {
}

variable "elb_apps_cert_id" {
}

variable "pages_staging_cert_id" {

}

variable "sites_pages_staging_cert_id" {
  
}

variable "elb_subnets" {
  type = list(string)
}

variable "elb_security_groups" {
  type = list(string)
}

variable "stack_description" {
}

variable "rds_instance_type" {
  default = "db.m4.large"
}

variable "rds_db_size" {
  default = 100
}

variable "rds_db_name" {
  default = "ccdb"
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
  default = "cfdb"
}

variable "rds_password" {
}

variable "rds_subnet_group" {
}

variable "rds_security_groups" {
  type = list(string)
}

variable "rds_apply_immediately" {
  default = "false"
}

variable "rds_allow_major_version_upgrade" {
  default = "false"
}

variable "stack_prefix" {
}

variable "az1" {
  default = "us-gov-west-1a"
}

variable "az2" {
  default = "us-gov-west-1b"
}

variable "vpc_id" {
}

variable "private_route_table_az1" {
}

variable "private_route_table_az2" {
}

variable "services_cidr_1" {
}

variable "services_cidr_2" {
}

variable "aws_partition" {
}

variable "bucket_prefix" {
}

variable "log_bucket_name" {
}

variable "tcp_lb_count" {
  default = 0
}