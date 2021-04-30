resource "aws_vpc" "a" {
  provider = aws.use1

  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = "${var.app_name}-vpc-a"
  }
}

resource "aws_vpc" "b" {
  cidr_block           = "10.2.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = "${var.app_name}-vpc-b"
  }
}

resource "aws_internet_gateway" "a" {
  provider = aws.use1

  vpc_id = aws_vpc.a.id

  tags = {
    Name = "${var.app_name}-igw-a"
  }
}

resource "aws_internet_gateway" "b" {
  vpc_id = aws_vpc.b.id

  tags = {
    Name = "${var.app_name}-igw-b"
  }
}

resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id = aws_vpc.a.id
  vpc_id      = aws_vpc.b.id
  peer_region = "us-east-1"
  auto_accept = false
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.use1
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_options" "requester" {

  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider = aws.use1

  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}
resource "aws_vpc_endpoint" "apigw" {
  vpc_id            = aws_vpc.b.id
  service_name      = "com.amazonaws.ap-northeast-1.execute-api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.b.id]
  subnet_ids         = [aws_subnet.b_public.id]

  private_dns_enabled = true
}
