resource "aws_route_table" "a_public" {
  provider = aws.use1

  vpc_id = aws_vpc.a.id

  route {
    cidr_block = aws_vpc.b.cidr_block
    gateway_id = aws_vpc_peering_connection.peer.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.a.id
  }

  tags = {
    Name = "${var.app_name}-vpc-a-public-route-table"
  }
}

resource "aws_route_table" "b_public" {
  vpc_id = aws_vpc.b.id

  route {
    cidr_block = aws_vpc.a.cidr_block
    gateway_id = aws_vpc_peering_connection.peer.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.b.id
  }

  tags = {
    Name = "${var.app_name}-vpc-b-public-route-table"
  }
}

resource "aws_route_table_association" "public_a" {
  provider = aws.use1

  subnet_id      = aws_subnet.a_public.id
  route_table_id = aws_route_table.a_public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.b_public.id
  route_table_id = aws_route_table.b_public.id
}
