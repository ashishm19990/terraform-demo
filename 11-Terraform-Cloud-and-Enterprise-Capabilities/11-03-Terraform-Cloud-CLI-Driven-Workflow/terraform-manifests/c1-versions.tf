# Terraform Block
terraform {
  required_version = "~> 1.2" # which means any version equal & above 1.2 like 1.2.x, 1.3.x etc and < 2.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # Update Terraform Cloud Backend Block Information below
  backend "remote" {
    organization = "zensar-parshv"

    workspaces {
      name = "cli-driven-demo"
    }
  }
}

# Provider Block
provider "aws" {
  region = var.aws_region
}
/*
Note-1:  AWS Credentials Profile (profile = "default") configured on your local desktop terminal  
$HOME/.aws/credentials
*/