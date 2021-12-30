provider aws {

}
# note, we'll need to move this to terraform.required_providers.aws.configuration_aliases when we update to 1.x (or maybe 0.15?)
provider aws {
  alias = "tooling"
}
/*
 * Variables required:
 *   peer_owner_id
 *   source_az1_route_table
 *   source_az2_route_table
 *   target_az1_route_table
 *   target_az2_route_table
 *   target_vpc_id
 *   target_vpc_cidr
 *   source_vpc_id
 *   source_vpc_cidr
 */

# Create peering connection for source_vpc_id -> target_vpc_id
data "aws_caller_identity" "tooling" {
  provider = aws.tooling
}

resource "aws_vpc_peering_connection" "peering" {
  peer_owner_id = data.aws_caller_identity.tooling.account_id
  peer_vpc_id   = var.target_vpc_id
  auto_accept   = false
  vpc_id        = var.source_vpc_id

  tags = {
    Name = "${var.source_vpc_id} to ${var.target_vpc_id}"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.tooling
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  auto_accept               = true

  tags = {
    Name = "${var.source_vpc_id} to ${var.target_vpc_id}"
  }
}

# Add peering connection to target_az1_route_table with source_vpc_cidr
resource "aws_route" "target_az1_to_source_cidr" {
  provider = aws.tooling
  route_table_id            = var.target_az1_route_table
  destination_cidr_block    = var.source_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# Add peering connection to target_az2_route_table with source_vpc_cidr
resource "aws_route" "target_az2_to_source_cidr" {
  provider = aws.tooling
  route_table_id            = var.target_az2_route_table
  destination_cidr_block    = var.source_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# add peering connection to source_az1_route_table with target_vpc_cidr
resource "aws_route" "source_az1_to_target_cidr" {
  route_table_id            = var.source_az1_route_table
  destination_cidr_block    = var.target_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# add peering connection to source_az2_route_table with target_vpc_cidr
resource "aws_route" "source_az2_to_target_cidr" {
  route_table_id            = var.source_az2_route_table
  destination_cidr_block    = var.target_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

