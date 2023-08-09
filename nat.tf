/*
This resource creates a NAT Gateway, which allows private instances in the VPC 
to access the internet via the public subnets (publicly routable IP address).
*/
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat"
  }
}

/* 
The allocation_id attribute refers to the ID of the Elastic IP (aws_eip.nat.id) created in the previous step. 
This Elastic IP will be used by the NAT Gateway to forward traffic from private instances to the internet.
*/
resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id

  /*
  The subnet_id attribute specifies the public subnet (aws_subnet.public-eu-west-1a.id) in which the NAT Gateway should reside. 
  This public subnet must have a route to an Internet Gateway (aws_internet_gateway.igw) to enable internet access.
  */

  subnet_id     = aws_subnet.public-eu-central-1a.id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}
