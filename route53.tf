# -----------------------------------------------------------------------------
# Base DNS
# -----------------------------------------------------------------------------
resource "aws_route53_zone" "cluster" {
  name    = var.base_domain_name
  comment = "Base domain name for ${var.cluster_name} resources"

  tags = {
    Name    = "${var.cluster_short_name}-base"
    Cluster = var.cluster_short_name
  }
}

# -----------------------------------------------------------------------------
# Internal DNS
# -----------------------------------------------------------------------------
locals {
  internal_private_hosted_zone = var.vpc_enable_dns_support && var.vpc_enable_dns_hostnames && var.internal_private_hosted_zone
}

resource "aws_route53_zone" "cluster_internal" {
  count = local.internal_private_hosted_zone ? 0 : 1

  name    = "${var.internal_subdomain_name}.${var.base_domain_name}"
  comment = "Base domain name for internal ${var.cluster_name} resources"

  tags = {
    Name    = "${var.cluster_short_name}-internal-base"
    Cluster = var.cluster_short_name
  }
}

resource "aws_route53_zone" "cluster_internal_private" {
  count = local.internal_private_hosted_zone ? 1 : 0

  name    = "${var.internal_subdomain_name}.${var.base_domain_name}"
  comment = "Base domain name for internal ${var.cluster_name} resources"

  vpc {
    vpc_id = aws_vpc.cluster.id
  }

  tags = {
    Name    = "${var.cluster_short_name}-internal-base"
    Cluster = var.cluster_short_name
  }
}

resource "aws_route53_record" "cluster_internal_ns" {
  count = local.internal_private_hosted_zone ? 0 : 1

  name    = element(aws_route53_zone.cluster_internal[*].name, count.index)
  type    = "NS"
  ttl     = 172800
  zone_id = aws_route53_zone.cluster.id
  records = element(aws_route53_zone.cluster_internal[*].name_servers, count.index)

  lifecycle {
    create_before_destroy = true
  }
}
