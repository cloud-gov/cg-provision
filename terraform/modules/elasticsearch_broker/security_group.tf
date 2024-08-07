resource "aws_security_group" "elasticsearch" {
  description = "Allow access to incoming elasticsearch traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = var.security_groups
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = var.security_groups
  }

  tags = {
    Name = "${var.stack_description} - Incoming Elasticsearch Traffic"
  }
}
