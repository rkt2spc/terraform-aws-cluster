resource "aws_eip" "cluster_nat_gateway" {
  count = var.nat_gateway ? min(length(aws_subnet.public_subnets), var.nat_gateway_per_availability_zone ? length(data.aws_availability_zones.available.names) : 1) : 0

  vpc = true

  tags = {
    Name    = var.nat_gateway_per_availability_zone ? "${var.cluster_short_name}-nat-gateway-${replace(element(aws_subnet.public_subnets[*].availability_zone, count.index), data.aws_region.current.name, "")}" : "${var.cluster_short_name}-nat-gateway"
    Cluster = var.cluster_short_name
  }
}

resource "aws_nat_gateway" "cluster" {
  count = var.nat_gateway ? min(length(aws_subnet.public_subnets), var.nat_gateway_per_availability_zone ? length(data.aws_availability_zones.available.names) : 1) : 0

  allocation_id = aws_eip.cluster_nat_gateway[count.index].id
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)

  tags = {
    Name    = var.nat_gateway_per_availability_zone ? "${var.cluster_short_name}-nat-gateway-${replace(element(aws_subnet.public_subnets[*].availability_zone, count.index), data.aws_region.current.name, "")}" : "${var.cluster_name}"
    Cluster = var.cluster_short_name
  }
}
