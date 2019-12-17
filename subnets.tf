locals {
  azs = sort(data.aws_availability_zones.available.names)

  // AWS VPC(s) have a fixed /56 IPv6 netmask
  // AWS Subnet(s) have a fixed /64 IPv6 netmask
  // Number of available IPv6 CIDR blocks is 2^(64-56) = 2^8
  allocateable_ipv6_cidr_blocks                = pow(2, 8)
  public_subnets_allocateable_ipv6_cidr_blocks = local.allocateable_ipv6_cidr_blocks - length(var.private_subnets_cidr_blocks)

  private_subnets_assign_ipv6_cidr_blocks = var.vpc_assign_generated_ipv6_cidr_block && var.private_subnets_assign_ipv6_cidr_blocks ? true : false
  public_subnets_assign_ipv6_cidr_blocks  = var.vpc_assign_generated_ipv6_cidr_block && var.public_subnets_assign_ipv6_cidr_blocks ? true : false
}

resource "aws_subnet" "private_subnets" {
  depends_on = [aws_vpc_ipv4_cidr_block_association.additional_ipv4_cidr_blocks]
  count      = length(var.private_subnets_cidr_blocks)

  vpc_id            = aws_vpc.cluster.id
  availability_zone = element(local.azs, count.index)

  cidr_block      = var.private_subnets_cidr_blocks[count.index]
  ipv6_cidr_block = local.private_subnets_assign_ipv6_cidr_blocks ? cidrsubnet(aws_vpc.cluster.ipv6_cidr_block, 8, count.index) : null

  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = local.private_subnets_assign_ipv6_cidr_blocks && var.private_subnets_assign_ipv6_address_on_creation

  tags = {
    Name    = "${var.cluster_short_name}-pvt-${replace(element(local.azs, count.index), data.aws_region.current.name, "")}"
    Cluster = var.cluster_short_name
  }
}

resource "aws_subnet" "public_subnets" {
  depends_on = [aws_vpc_ipv4_cidr_block_association.additional_ipv4_cidr_blocks]
  count      = length(var.public_subnets_cidr_blocks)

  vpc_id            = aws_vpc.cluster.id
  availability_zone = element(local.azs, count.index)

  cidr_block      = var.public_subnets_cidr_blocks[count.index]
  ipv6_cidr_block = local.public_subnets_assign_ipv6_cidr_blocks && count.index < local.public_subnets_allocateable_ipv6_cidr_blocks ? cidrsubnet(aws_vpc.cluster.ipv6_cidr_block, 8, local.allocateable_ipv6_cidr_blocks - count.index - 1) : null

  map_public_ip_on_launch         = var.public_subnets_map_public_ip_on_launch
  assign_ipv6_address_on_creation = local.public_subnets_assign_ipv6_cidr_blocks && var.public_subnets_assign_ipv6_address_on_creation

  tags = {
    Name    = "${var.cluster_short_name}-pub-${replace(element(local.azs, count.index), data.aws_region.current.name, "")}"
    Cluster = var.cluster_short_name
  }
}
