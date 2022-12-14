terraform {

  cloud {
    organization = "aws-sap"
    workspaces {
      name = "jenkins"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = local.common_tags
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}


locals {
  common_tags = {
    CreatedBy  = "terraform"
    CostCenter = "ChaseCreditCard"
  }

}
