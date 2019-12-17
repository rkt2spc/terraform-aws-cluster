locals {
  nat_gateway_ids_by_az = transpose({ for nat_gateway in aws_nat_gateway.cluster : nat_gateway.id => [aws_subnet.public_subnets[index(aws_subnet.public_subnets[*].id, nat_gateway.subnet_id)].availability_zone_id] })
}

resource "aws_route_table" "private_route_tables" {
  count = length(aws_subnet.private_subnets)

  vpc_id = aws_vpc.cluster.id

  tags = {
    Name    = "${var.cluster_short_name}-pvt-${replace(element(aws_subnet.private_subnets[*].availability_zone, count.index), data.aws_region.current.name, "")}"
    Cluster = var.cluster_short_name
  }
}

resource "aws_route_table_association" "private_route_tables_associations" {
  count = length(aws_subnet.private_subnets)

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[count.index].id
}

resource "aws_route" "private_route_nat_gateway" {
  count = var.nat_gateway ? length(aws_subnet.private_subnets) : 0

  route_table_id = aws_route_table.private_route_tables[count.index].id

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = element(
    lookup(
      local.nat_gateway_ids_by_az,
      aws_subnet.private_subnets[count.index].availability_zone_id,
      aws_nat_gateway.cluster[*].id,
    ),
    count.index,
  )
}

resource "aws_route" "private_route_egress_only_internet_gateway" {
  count = var.egress_only_internet_gateway ? length(aws_subnet.private_subnets) : 0

  route_table_id = aws_route_table.private_route_tables[count.index].id

  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = element(aws_egress_only_internet_gateway.cluster[*].id, count.index)
}

resource "aws_route_table" "public_route_tables" {
  count = length(aws_subnet.public_subnets)

  vpc_id = aws_vpc.cluster.id

  tags = {
    Name    = "${var.cluster_short_name}-pub-${replace(element(aws_subnet.public_subnets[*].availability_zone, count.index), data.aws_region.current.name, "")}"
    Cluster = var.cluster_short_name
  }
}

resource "aws_route_table_association" "public_route_tables_associations" {
  count = length(aws_subnet.public_subnets)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_tables[count.index].id
}

resource "aws_route" "public_route_internet_gateway_ipv4" {
  count = var.internet_gateway ? length(aws_subnet.public_subnets) : 0

  route_table_id = aws_route_table.public_route_tables[count.index].id

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = element(aws_internet_gateway.cluster[*].id, count.index)
}

resource "aws_route" "public_route_internet_gateway_ipv6" {
  count = var.internet_gateway ? length(aws_subnet.public_subnets) : 0

  route_table_id = aws_route_table.public_route_tables[count.index].id

  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = element(aws_internet_gateway.cluster[*].id, count.index)
}
