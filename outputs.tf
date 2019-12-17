# -----------------------------------------------------------------------------
# Subnets
# -----------------------------------------------------------------------------
output "private_subnets" {
  value = aws_subnet.private_subnets[*].id
}

output "public_subnets" {
  value = aws_subnet.public_subnets[*].id
}

# -----------------------------------------------------------------------------
# ACM
# -----------------------------------------------------------------------------
output "cert_arn" {
  value = aws_acm_certificate.cluster.arn
}

output "internal_cert_arn" {
  value = aws_acm_certificate.cluster_internal.arn
}

output "external_cert_arn" {
  value = aws_acm_certificate.cluster.arn
}

# -----------------------------------------------------------------------------
# Route53
# -----------------------------------------------------------------------------
output "dns_zone" {
  value = aws_route53_zone.cluster.id
}

output "internal_dns_zone" {
  value = element(local.internal_private_hosted_zone ? aws_route53_zone.cluster_internal_private[*].id : aws_route53_zone.cluster_internal[*].id, 0)
}

output "external_dns_zone" {
  value = aws_route53_zone.cluster.id
}
