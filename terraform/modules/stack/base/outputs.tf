/* VPC */
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

/* Private network */
output "private_subnet_az1" {
  value = module.vpc.private_subnet_az1
}

output "private_subnet_az2" {
  value = module.vpc.private_subnet_az2
}

output "private_route_table_az1" {
  value = module.vpc.private_route_table_az1
}

output "private_route_table_az2" {
  value = module.vpc.private_route_table_az2
}

output "private_cidr_az1" {
  value = module.vpc.private_cidr_az1
}

output "private_cidr_az2" {
  value = module.vpc.private_cidr_az2
}

output "vpc_endpoint_customer_s3_if1_ip" {
  value = module.vpc.vpc_endpoint_customer_s3_if1_ip
}

output "vpc_endpoint_customer_s3_if2_ip" {
  value = module.vpc.vpc_endpoint_customer_s3_if2_ip
}

output "vpc_endpoint_customer_s3_dns" {
  value = module.vpc.vpc_endpoint_customer_s3_dns
}

/* Public network */
output "public_subnet_az1" {
  value = module.vpc.public_subnet_az1
}

output "public_subnet_az2" {
  value = module.vpc.public_subnet_az2
}

output "public_route_table" {
  value = module.vpc.public_route_table
}

output "public_cidr_az1" {
  value = module.vpc.public_cidr_az1
}

output "public_cidr_az2" {
  value = module.vpc.public_cidr_az2
}

output "nat_egress_ip_az1" {
  value = module.vpc.nat_egress_ip_az1
}

output "nat_egress_ip_az2" {
  value = module.vpc.nat_egress_ip_az2
}

output "nat_gateway_egress_ip_set_arn" {
  value = module.vpc.nat_gateway_egress_ip_set_arn
}

/* Security Groups */
output "bosh_security_group" {
  value = module.vpc.bosh_security_group
}

output "local_vpc_traffic_security_group" {
  value = module.vpc.local_vpc_traffic_security_group
}

output "web_traffic_security_group" {
  value = module.vpc.web_traffic_security_group
}

output "restricted_web_traffic_security_group" {
  value = module.vpc.restricted_web_traffic_security_group
}

/* RDS Network */
output "rds_subnet_az1" {
  value = module.rds_network.rds_subnet_az1
}

output "rds_subnet_az2" {
  value = module.rds_network.rds_subnet_az2
}

output "rds_subnet_az3" {
  value = module.rds_network.rds_subnet_az3
}

output "rds_subnet_az4" {
  value = module.rds_network.rds_subnet_az4
}

output "rds_private_cidr_1" {
  value = module.rds_network.rds_private_cidr_1
}

output "rds_private_cidr_2" {
  value = module.rds_network.rds_private_cidr_2
}

output "rds_private_cidr_3" {
  value = module.rds_network.rds_private_cidr_3
}

output "rds_private_cidr_4" {
  value = module.rds_network.rds_private_cidr_4
}

output "rds_subnet_group" {
  value = module.rds_network.rds_subnet_group
}

output "rds_mysql_security_group" {
  value = module.rds_network.rds_mysql_security_group
}

output "rds_postgres_security_group" {
  value = module.rds_network.rds_postgres_security_group
}

output "rds_mssql_security_group" {
  value = module.rds_network.rds_mssql_security_group
}

output "rds_oracle_security_group" {
  value = module.rds_network.rds_oracle_security_group
}

/* RDS Bosh Instance */
output "bosh_rds_url_curr" {
  value = module.rds.rds_url
}

output "bosh_rds_host_curr" {
  value = module.rds.rds_host
}

output "bosh_rds_url_prev" {
  value = ""
}

output "bosh_rds_host_prev" {
  value = ""
}

output "bosh_rds_port" {
  value = module.rds.rds_port
}

output "bosh_rds_username" {
  value = module.rds.rds_username
}

output "bosh_rds_password" {
  value     = module.rds.rds_password
  sensitive = true
}

/*
 * CredHub RDS Instance
 */

output "credhub_rds_identifier" {
  value = module.credhub_rds.rds_identifier
}

output "credhub_rds_name" {
  value = module.credhub_rds.rds_name
}

output "credhub_rds_host" {
  value = module.credhub_rds.rds_host
}

output "credhub_rds_port" {
  value = module.credhub_rds.rds_port
}

output "credhub_rds_url" {
  value = module.credhub_rds.rds_url
}

output "credhub_rds_username" {
  value = module.credhub_rds.rds_username
}

output "credhub_rds_password" {
  value     = module.credhub_rds.rds_password
  sensitive = true
}

output "default_key_name" {
  value = module.vpc.default_key_name
}
