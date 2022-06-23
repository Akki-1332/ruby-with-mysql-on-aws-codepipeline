resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  tags = {
    Name = "TF-VPC"
  }
}

resource "aws_subnet" "main" {
  count = length(var.subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.subnet_cidr, count.index)
  availability_zone = element(var.az, count.index)
  map_public_ip_on_launch = element(var.public_ip, count.index)

  tags = {
    Name = "Subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "TF-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "PublicRT"
  }
  depends_on = [
    aws_internet_gateway.gw
  ]
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.main[0].id
  route_table_id = aws_route_table.public_rt.id
  depends_on = [
    aws_route_table.public_rt
  ]
}

resource "aws_eip" "nat" {
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main[0].id 

  tags = {
    Name = "TF-NAT-gw"
  }
  depends_on = [
      aws_route_table_association.public
  ]
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "PrivateRT"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.subnet_cidr)
  subnet_id = aws_subnet.main[1].id
  route_table_id = aws_route_table.private_rt.id
}
