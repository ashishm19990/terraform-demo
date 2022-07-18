# Create S3 Bucket
resource "aws_s3_bucket" "terraform_bucket" {

/*
  bucket = "state-import-bucket-101"
  acl = "private"
  force_destroy = false
*/

}

# terraform import aws_s3_bucket.terraform_bucket state-import-bucket-101