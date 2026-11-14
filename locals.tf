locals {
  common-name = "${var.project}-${var.environment}"
  common-tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
    Name        = local.common-name
  }

  az-required = slice(data.aws_availability_zones.main.names, 0, 2)


}