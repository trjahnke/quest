provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket  = "terraform-state-ecs-quest"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = "default"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.69.0"
    }
  }
}