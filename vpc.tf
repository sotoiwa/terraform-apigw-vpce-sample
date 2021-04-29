resource "aws_vpc" "a" {
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

resource "aws_vpc_peering_connection" "this" {
  peer_vpc_id = aws_vpc.a.id
  vpc_id      = aws_vpc.b.id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_endpoint" "apigw" {
  vpc_id            = aws_vpc.b.id
  service_name      = "com.amazonaws.ap-northeast-1.execute-api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.b.id]
  subnet_ids         = [aws_subnet.b_public_a.id]

  private_dns_enabled = true
}
