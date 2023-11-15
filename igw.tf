/*
By associating the Internet Gateway with a VPC, the private instances within 
the VPC can communicate with the internet and vice versa. 
It enables instances in the VPC to have public IP addresses and access the internet directly.
*/
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}
