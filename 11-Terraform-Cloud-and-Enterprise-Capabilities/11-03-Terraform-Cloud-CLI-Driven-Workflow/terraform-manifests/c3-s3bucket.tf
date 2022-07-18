# Call our Custom Terraform Module which we built earlier
module "website_s3_bucket" {
  source  = "app.terraform.io/Zensar-netgear/s3-website/aws"
  version = "1.0.1"
  # insert required variables here
  bucket_name = var.terraform_s3_bucket
  tags        = var.terraform_s3_tags
}
