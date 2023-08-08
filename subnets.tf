resource "aws_subnet" "private-eu-west-1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "eu-west-1a"

# A tag with a Kubernetes-specific key and value indicating the role of the 
# subnet in the Kubernetes cluster.
  tags = {
    "Name"                            = "private-eu-west-1a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

resource "aws_subnet" "private-eu-west-1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "eu-west-1b"

  # A tag with a Kubernetes-specific key and value indicating the role of the subnet 
  # in the Kubernetes cluster.
  tags = {
    "Name"                            = "private-eu-west-1b"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

resource "aws_subnet" "public-eu-west-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "eu-west-1a"

  #  This line indicates that instances launched within this subnet will have public 
  # IP addresses automatically assigned to them. This is useful for instances that 
  # need to communicate with the internet directly.
  map_public_ip_on_launch = true

  tags = {
    "Name"                       = "public-eu-west-1a"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  }
}

resource "aws_subnet" "public-eu-west-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                       = "public-eu-west-1b"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  }
}
