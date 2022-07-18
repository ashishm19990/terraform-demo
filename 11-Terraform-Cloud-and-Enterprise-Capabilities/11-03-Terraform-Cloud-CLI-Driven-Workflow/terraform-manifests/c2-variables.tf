# Input Variables
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}

## Create Variable for S3 Bucket Name
variable "terraform_s3_bucket" {
  description = "S3 Bucket name that we pass to S3 Custom Module"
  type        = string
  default     = "terraform-bucket-1051"
}

## Create Variable for S3 Bucket Tags
variable "terraform_s3_tags" {
  description = "Tags to set on the bucket"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
    newtag1     = "tag1"
    newtag2     = "tag2"
    #newtag3 = "tag3"    # Enable during Step-10
  }
}
