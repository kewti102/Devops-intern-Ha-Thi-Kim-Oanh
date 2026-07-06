# Day 8 — Terraform AWS VPC + EC2 Lab

## Prerequisites

- Terraform >= 1.6
- AWS CLI configured with profile `terraform-day3`
- Region: ap-southeast-1
- Do not commit `terraform.tfvars`, `.terraform/`, or `*.tfstate`.

## Run

```bash
export AWS_PROFILE=terraform-day3
export AWS_REGION=ap-southeast-1

terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply EOF
