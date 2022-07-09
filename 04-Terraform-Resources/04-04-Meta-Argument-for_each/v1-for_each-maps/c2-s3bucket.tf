# Create S3 Bucket per environment with for_each and maps
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

resource "aws_s3_bucket" "terraform_s3_bucket" {

  # for_each Meta-Argument
  for_each = {
    dev  = "my-dapp1-bucket"
    qa   = "my-qapp1-bucket"
    stag = "my-sapp1-bucket"
    prod = "my-papp1-bucket"
  }

  bucket = "${each.key}-${each.value}"
  acl    = "private"

  tags = {
    Environment = each.key
    bucketname  = "${each.key}-${each.value}"
    eachvalue   = each.value
  }
}
