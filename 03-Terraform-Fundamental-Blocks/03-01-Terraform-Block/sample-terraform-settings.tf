terraform {
  # Required Terraform Version
  required_version = "~> 1.2"
  # Required Providers and their Versions
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0" # Optional but recommended
    }
    random = {
      source = "hashicorp/random"
      version = "3.2.2"
    }
  }
  # Remote Backend for storing Terraform State in S3 bucket 
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
  # Experimental Features (Not required)
  experiments = [ example ]
  # Passing Metadata to Providers (Super Advanced - Terraform documentation says not needed in many cases)
  provider_meta "my-provider" {
    hello = "world"
  }
}