# Resource 15 Create Elastic IP
resource "aws_eip" "terraform_eip" {
  vpc = true
  # Meta Argument
  depends_on = [aws_internet_gateway.terraform_igw]
}
