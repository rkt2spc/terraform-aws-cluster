data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
}

resource "aws_vpc_endpoint" "s3" {
  count = var.vpc_endpoint_s3 ? 1 : 0

  vpc_id            = aws_vpc.cluster.id
  vpc_endpoint_type = data.aws_vpc_endpoint_service.s3.service_type
  service_name      = data.aws_vpc_endpoint_service.s3.service_name
  route_table_ids   = concat(aws_route_table.private_route_tables[*].id, aws_route_table.public_route_tables[*].id)

  tags = {
    Name    = "${var.cluster_short_name}-s3-${lower(data.aws_vpc_endpoint_service.s3.service_type)}"
    Cluster = var.cluster_short_name
  }
}

data "aws_vpc_endpoint_service" "dynamodb" {
  service = "dynamodb"
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.vpc_endpoint_dynamodb ? 1 : 0

  vpc_id            = aws_vpc.cluster.id
  vpc_endpoint_type = data.aws_vpc_endpoint_service.dynamodb.service_type
  service_name      = data.aws_vpc_endpoint_service.dynamodb.service_name
  route_table_ids   = concat(aws_route_table.private_route_tables[*].id, aws_route_table.public_route_tables[*].id)

  tags = {
    Name    = "${var.cluster_short_name}-dynamodb-${lower(data.aws_vpc_endpoint_service.dynamodb.service_type)}"
    Cluster = var.cluster_short_name
  }
}
