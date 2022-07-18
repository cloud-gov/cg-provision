variable "elb_subnets" {
  type = list(string)
}

variable "listeners_per_tcp_lb" {
  default = 10
}

variable "stack_description" {}

variable "tcp_allow_cidrs_ipv4" {
  default = ["0.0.0.0/0"]
}

variable "tcp_allow_cidrs_ipv6" {
  default = ["::/0"]
}

variable "tcp_first_port" {
  type = number
}

variable "vpc_id" {}

