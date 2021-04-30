resource "aws_subnet" "a_public" {
  provider = aws.use1

  vpc_id                  = aws_vpc.a.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-a-public-subnet"
  }
}

resource "aws_subnet" "b_public" {
  vpc_id                  = aws_vpc.b.id
  cidr_block              = "10.2.1.0/24"
  availability_zone       = "${data.aws_region.this.name}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-b-public-subnet"
  }
}
