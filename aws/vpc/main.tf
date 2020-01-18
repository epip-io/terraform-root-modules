provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, var.availability_zones)
}

module "vpc" {
  source = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.1"

  namespace                      = var.namespace
  stage                          = var.stage
  name                           = var.name
  delimiter                      = var.delimiter
  attributes                     = var.attributes
  tags                           = var.tags
  cidr_block                     = var.cidr_block
  instance_tenancy               = var.instance_tenancy
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_dns_support             = var.enable_dns_support
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support
}

module "subnets" {
  source = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=0.16.1"

  namespace                    = var.namespace
  stage                        = var.stage
  name                         = var.name
  delimiter                    = var.delimiter
  attributes                   = var.attributes
  tags                         = var.tags
  cidr_block                   = module.vpc.vpc_cidr_block
  subnet_type_tag_key          = var.subnet_type_tag_key
  subnet_type_tag_value_format = var.subnet_type_tag_value_format
  max_subnet_count             = var.max_subnet_count
  vpc_id                       = module.vpc.vpc_id
  igw_id                       = module.vpc.igw_id
  availability_zones           = local.availability_zones
  vpc_default_route_table_id   = module.vpc.vpc_default_route_table_id
  public_network_acl_id        = var.public_network_acl_id
  private_network_acl_id       = var.private_network_acl_id
  nat_gateway_enabled          = var.nat_gateway_enabled
  nat_instance_enabled         = var.nat_instance_enabled
  nat_instance_type            = var.nat_instance_type
  map_public_ip_on_launch      = var.map_public_ip_on_launch
}
