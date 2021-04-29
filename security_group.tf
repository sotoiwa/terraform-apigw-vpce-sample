resource "aws_security_group" "a" {
  name   = "${var.app_name}-a-sg"
  vpc_id = aws_vpc.a.id
}

resource "aws_security_group_rule" "a" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.a.id
}

resource "aws_security_group_rule" "a_1" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.a.id
  security_group_id        = aws_security_group.a.id
}

resource "aws_security_group_rule" "a_2" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.b.cidr_block]
  security_group_id = aws_security_group.a.id
}

resource "aws_security_group_rule" "a_3" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.a.id
}

resource "aws_security_group" "b" {
  name   = "${var.app_name}-b-sg"
  vpc_id = aws_vpc.b.id
}

resource "aws_security_group_rule" "b" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.b.id
}

resource "aws_security_group_rule" "b_1" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.b.id
  security_group_id        = aws_security_group.b.id
}

resource "aws_security_group_rule" "b_2" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.a.cidr_block]
  security_group_id = aws_security_group.b.id
}

resource "aws_security_group_rule" "b_3" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.b.id
}
