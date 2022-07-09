# Create 4 IAM Users
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user

resource "aws_iam_user" "terraform_user" {
  for_each = toset(["TJack", "TJames", "TMadhu", "TDave"])
  name     = each.key
}
