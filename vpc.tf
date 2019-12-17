resource "aws_vpc" "cluster" {
  cidr_block                       = var.vpc_cidr_block
  instance_tenancy                 = var.vpc_instance_tenancy
  enable_dns_support               = var.vpc_enable_dns_support
  enable_dns_hostnames             = var.vpc_enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.vpc_assign_generated_ipv6_cidr_block

  tags = {
    Name    = var.cluster_name
    Cluster = var.cluster_short_name
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "additional_ipv4_cidr_blocks" {
  count = length(var.vpc_additional_ipv4_cidr_blocks)

  vpc_id     = aws_vpc.cluster.id
  cidr_block = var.vpc_additional_ipv4_cidr_blocks[count.index]
}
