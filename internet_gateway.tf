resource "aws_internet_gateway" "cluster" {
  count = var.internet_gateway ? 1 : 0

  vpc_id = aws_vpc.cluster.id

  tags = {
    Name    = var.cluster_name
    Cluster = var.cluster_short_name
  }
}
