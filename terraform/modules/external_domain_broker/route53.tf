# These resources are for https://github.com/cloud-gov/external-domain-broker

resource "aws_route53_zone" "zone" {
  name    = "external-domains-${var.stack_description}.cloud.gov"
  comment = "Hosts TXT and CNAME records for the external-domain-broker"
}

data "aws_route53_zone" "cloud_gov" {
  name = "cloud.gov"
}

resource "aws_route53_record" "record" {
  name    = aws_route53_zone.zone.name
  zone_id = data.aws_route53_zone.cloud_gov.zone_id
  type    = "NS"
  ttl     = "60"

  records = [
    aws_route53_zone.zone.name_servers[0],
    aws_route53_zone.zone.name_servers[1],
    aws_route53_zone.zone.name_servers[2],
    aws_route53_zone.zone.name_servers[3],
  ]
}
