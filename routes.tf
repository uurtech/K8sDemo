resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  
  /* 
  The route block defines a route that forwards all traffic (0.0.0.0/0) to 
  a Network Address Translation (NAT) gateway (aws_nat_gateway.nat) associated with the VPC. 
  This setup allows private instances in the subnets to access the internet via the NAT gateway 
  while not being directly exposed to the internet.
  */
  // target default
  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      nat_gateway_id             = aws_nat_gateway.nat.id
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    },
  ]

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

/*
The route block defines a default route (0.0.0.0/0) that forwards all traffic to an 
Internet Gateway (aws_internet_gateway.igw) associated with the VPC. 
This setup allows instances in the subnets associated with this route table to have direct access to the internet.
 */

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_internet_gateway.igw.id
      nat_gateway_id             = ""
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    },
  ]

  tags = {
    Name = "public"
  }
}

/* associations */
resource "aws_route_table_association" "private-eu-west-1a" {
  subnet_id      = aws_subnet.private-eu-west-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-eu-west-1b" {
  subnet_id      = aws_subnet.private-eu-west-1b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-eu-west-1a" {
  subnet_id      = aws_subnet.public-eu-west-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-eu-west-1b" {
  subnet_id      = aws_subnet.public-eu-west-1b.id
  route_table_id = aws_route_table.public.id
}
