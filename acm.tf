resource "aws_acm_certificate" "cluster" {
  domain_name               = var.base_domain_name
  subject_alternative_names = ["*.${var.base_domain_name}"]
  validation_method         = "DNS"

  tags = {
    Name    = "${var.cluster_short_name}-base"
    Cluster = var.cluster_short_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cluster_cert_validation" {
  name    = aws_acm_certificate.cluster.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cluster.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.cluster.id
  records = [aws_acm_certificate.cluster.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate" "cluster_internal" {
  domain_name               = "${var.internal_subdomain_name}.${var.base_domain_name}"
  subject_alternative_names = ["*.${var.internal_subdomain_name}.${var.base_domain_name}"]
  validation_method         = "DNS"

  tags = {
    Name    = "${var.cluster_short_name}-internal-base"
    Cluster = var.cluster_short_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cluster_internal_cert_validation" {
  name    = aws_acm_certificate.cluster_internal.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cluster_internal.domain_validation_options[0].resource_record_type
  zone_id = local.internal_private_hosted_zone ? aws_route53_zone.cluster.id : element(aws_route53_zone.cluster_internal[*].id, 0)
  records = [aws_acm_certificate.cluster_internal.domain_validation_options[0].resource_record_value]
  ttl     = 60
}
