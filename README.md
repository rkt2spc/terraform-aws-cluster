# AWS Cluster Terraform module

Terraform module for setting up a standard public/private subnets cluster on AWS

## Basic Usage

```terraform
module "cluster" {
  source = "../modules/cluster"

  cluster_name       = "production"
  cluster_short_name = "prd"

  vpc_cidr_block = "10.0.0.0/16"

  private_subnets_cidr_blocks = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
  ]

  public_subnets_cidr_blocks = [
    "10.0.128.0/24",
    "10.0.129.0/24",
    "10.0.130.0/24",
  ]

  base_domain_name = "example.com"
}
```
