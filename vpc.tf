resource "aws_vpc" "main" {
  cidr_block = "10.190.0.0/16"

  tags = {
    Name = "main"
  }
}
