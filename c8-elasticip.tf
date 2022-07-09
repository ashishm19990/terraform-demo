# Create Elastic IP for Bastion Host
# Resource - depends_on Meta-Argument
resource "aws_eip" "terraform_eip" {
  depends_on = [aws_internet_gateway.terraform_igw]
  vpc        = true
  tags = {
    Name        = "${local.name}-terraform-eip"
    Environment = "${var.environment}"
  }

  ## Local Exec Provisioner:  local-exec provisioner (Destroy-Time Provisioner - Triggered during deletion of Resource)
  provisioner "local-exec" {
    command     = "echo Destroy time prov `date` >> destroy-time-prov.txt"
    working_dir = "local-exec-output-files/"
    when        = destroy
    #on_failure = continue
  }
}
