resource "aws_egress_only_internet_gateway" "cluster" {
  count = var.egress_only_internet_gateway ? 1 : 0

  vpc_id = aws_vpc.cluster.id
}
