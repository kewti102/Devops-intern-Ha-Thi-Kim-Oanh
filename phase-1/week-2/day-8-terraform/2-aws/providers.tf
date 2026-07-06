locals {
  common_tags = {
    Project = "devops-training"
    Owner   = var.owner
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = local.common_tags
  }
}
