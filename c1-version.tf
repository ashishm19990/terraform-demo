terraform {
  required_version = "~> 1.2" # which means any version equal & above 1.2 like 1.1, 1.2 etc and < 1.3.x
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}
