resource "aws_lb" "cf_uaa" {
  name = "${var.stack_description}-cloudfoundry-uaa"
  subnets = var.elb_subnets
  security_groups = var.elb_security_groups
  ip_address_type = "dualstack"
  idle_timeout = 3600
  access_logs {
    bucket  = var.log_bucket_name
    prefix  = var.stack_description
    enabled = true
  }
}

resource "aws_lb_target_group" "cf_uaa_target" {
  name     = "${var.stack_description}-cf-uaa"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 2
    interval            = 5
    port                = 81
    timeout             = 4
    unhealthy_threshold = 3
    matcher             = 200
  }
}

resource "aws_lb_listener" "cf_uaa" {
  load_balancer_arn = aws_lb.cf_uaa.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = var.elb_main_cert_id

  default_action {
    target_group_arn = aws_lb_target_group.cf_uaa_target.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "cf_uaa_http" {
  load_balancer_arn = aws_lb.cf_uaa.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.cf_uaa_target.arn
    type             = "forward"
  }
}

resource "aws_wafv2_web_acl" "uaa-core" {
  name        = "uaa-core-rule"
  description = "UAA ELB WAF Rules"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "aws-managed-rule"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "uaa-core-metric"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "uaa-core" {
  resource_arn = aws_lb.cf_uaa.arn
  web_acl_arn  = aws_wafv2_web_acl.uaa-core.arn
}
