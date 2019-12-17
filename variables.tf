# -----------------------------------------------------------------------------
# Cluster variables
# -----------------------------------------------------------------------------
variable "cluster_name" {
  type        = string
  description = "Name of the cluster."
}

variable "cluster_short_name" {
  type        = string
  description = "Short abbreviation of cluster name. Used for prefixing resources. Should be within 3-4 characters."
}

# -----------------------------------------------------------------------------
# VPC variables
# -----------------------------------------------------------------------------
variable "vpc_cidr_block" {
  type        = string
  description = "The default IPv4 CIDR block for the VPC."
}

variable "vpc_instance_tenancy" {
  type        = string
  description = "A tenancy option for instances launched into the VPC."
  default     = "default"
}

variable "vpc_enable_dns_support" {
  type        = bool
  description = "A boolean flag to enable/disable DNS support in the VPC."
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  type        = bool
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  default     = true
}

variable "vpc_assign_generated_ipv6_cidr_block" {
  type        = bool
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block."
  default     = true
}

variable "vpc_additional_ipv4_cidr_blocks" {
  type        = list(string)
  description = "Additional IPv4 CIDR blocks for the VPC."
  default     = []
}

# -----------------------------------------------------------------------------
# Internet Gateway variables
# -----------------------------------------------------------------------------
variable "internet_gateway" {
  type        = bool
  description = "Whether to create an internet gateway for the VPC. Can't imagine why you don't want this."
  default     = true
}

# -----------------------------------------------------------------------------
# NAT / Egress Only Gateway variables
# -----------------------------------------------------------------------------
variable "nat_gateway" {
  type        = bool
  description = "Whether to create a NAT gateway for the VPC private subnets. Useful if you need internet access in your private subnets."
  default     = true
}

variable "nat_gateway_per_availability_zone" {
  type        = bool
  description = "Create a separate NAT gateway for each of the region availability zone."
  default     = false
}

variable "egress_only_internet_gateway" {
  type        = bool
  description = "Whether to create an egress only internet gateway for the VPC public subnets. Useful if you need internet access over IPv6 in your private subnets."
  default     = false
}

# -----------------------------------------------------------------------------
# Private Subnet(s) variables
# -----------------------------------------------------------------------------
variable "private_subnets_cidr_blocks" {
  type        = list(string)
  description = "List of subnets IPv4 CIDR blocks"
  default     = []
}

variable "private_subnets_assign_ipv6_cidr_blocks" {
  type        = bool
  description = "Whether to assign IPv6 CIDR blocks to the subnets. Has no effect if the VPC isn't assigned a IPv6 CIDR block."
  default     = true
}

variable "private_subnets_assign_ipv6_address_on_creation" {
  type        = bool
  description = "Indicate that network interfaces created in the subnets should be assigned an IPv6 address. Has no effect if the VPC or the subnet isn't assigned a IPv6 CIDR block."
  default     = true
}

# -----------------------------------------------------------------------------
# Public Subnet(s) variables
# -----------------------------------------------------------------------------
variable "public_subnets_cidr_blocks" {
  type        = list(string)
  description = "List of subnets IPv4 CIDR blocks"
  default     = []
}

variable "public_subnets_assign_ipv6_cidr_blocks" {
  type        = bool
  description = "Whether to assign IPv6 CIDR blocks to the subnets. Has no effect if the VPC isn't assigned a IPv6 CIDR block."
  default     = true
}

variable "public_subnets_map_public_ip_on_launch" {
  type        = bool
  description = "Indicate whether to automatically assign a public IP address to instances launched inside the subnets."
  default     = true
}

variable "public_subnets_assign_ipv6_address_on_creation" {
  type        = bool
  description = "Indicate that network interfaces created in the subnets should be assigned an IPv6 address. Has no effect if the VPC or the subnet isn't assigned a IPv6 CIDR block."
  default     = true
}

# -----------------------------------------------------------------------------
# VPC Endpoints variables
# -----------------------------------------------------------------------------
variable "vpc_endpoint_s3" {
  type        = bool
  description = "Indidcate whether to create an S3 service gateway endpoint within the VPC"
  default     = true
}

variable "vpc_endpoint_dynamodb" {
  type        = bool
  description = "Indidcate whether to create an DynamoDB service gateway endpoint within the VPC"
  default     = true
}

# -----------------------------------------------------------------------------
# DNS variables
# -----------------------------------------------------------------------------
variable "base_domain_name" {
  type        = string
  description = "Fully qualified base domain name for the cluster resources."
}

variable "internal_subdomain_name" {
  type        = string
  description = "Will be concatenated to the cluster base domain name to create a separate namespace for internal resources."
  default     = "internal"
}

variable "internal_private_hosted_zone" {
  type        = bool
  description = "Whether to use private hosted zone for the internal base domain name. Only applicable if vpc_enable_dns_support and vpc_enable_dns_hostnames are enabled."
  default     = true
}

# -----------------------------------------------------------------------------
# Remote Data
# -----------------------------------------------------------------------------
data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}
