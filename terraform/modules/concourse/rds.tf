

module "rds" {
    source = "../rds"

    stack_description = "${var.stack_description}"
    rds_db_name = "${var.rds_db_name}"
    rds_instance_type = "${var.rds_instance_type}"
    rds_storage_type = "${var.rds_db_storage_type}"
    rds_db_size = "${var.rds_db_size}"
    rds_username = "${var.rds_username}"
    rds_password = "${var.rds_password}"
    rds_subnet_group = "${var.rds_subnet_group}"
    rds_security_groups = "${var.rds_security_groups}"
    rds_encrypted = "${var.rds_encrypted}"
}
