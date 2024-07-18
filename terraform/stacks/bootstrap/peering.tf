data "terraform_remote_state" "tooling_vpc" {
  count = var.use_vpc_peering

  backend = "s3"
  config = {
    bucket = var.tooling_state_bucket
    key    = "${var.tooling_stack_name}/terraform.tfstate"
  }
}

resource "aws_vpc_peering_connection" "peering" {
  count = var.use_vpc_peering

  vpc_id        = aws_default_vpc.bootstrap.id
  peer_owner_id = data.aws_caller_identity.current.account_id
  peer_vpc_id   = data.terraform_remote_state.tooling_vpc[0].outputs.vpc_id
  auto_accept   = true
}

resource "aws_route" "target_az1_to_source_cidr" {
  count = var.use_vpc_peering

  route_table_id            = data.terraform_remote_state.tooling_vpc[0].outputs.private_route_table_az1
  destination_cidr_block    = aws_default_vpc.bootstrap.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "target_az2_to_source_cidr" {
  count = var.use_vpc_peering

  route_table_id            = data.terraform_remote_state.tooling_vpc[0].outputs.private_route_table_az2
  destination_cidr_block    = aws_default_vpc.bootstrap.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "source_az1_to_target_cidr" {
  count = var.use_vpc_peering

  route_table_id            = data.aws_route_table.bootstrap.id
  destination_cidr_block    = data.terraform_remote_state.tooling_vpc[0].outputs.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_security_group_rule" "allow_all_bosh_default" {
  count = var.use_vpc_peering

  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_default_vpc.bootstrap.cidr_block]
  security_group_id = data.terraform_remote_state.tooling_vpc[0].outputs.bosh_security_group
}

resource "aws_security_group_rule" "allow_rds_postgres" {
  count = var.use_vpc_peering

  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = [aws_default_vpc.bootstrap.cidr_block]
  security_group_id = data.terraform_remote_state.tooling_vpc[0].outputs.rds_postgres_security_group
}

