terraform {
  required_version = ">= 0.12.26"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.36.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias   = "consumer"
  profile = var.consumer_profile
  region  = var.aws_region
}
