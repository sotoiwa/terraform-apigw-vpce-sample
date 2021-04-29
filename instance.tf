data "aws_ssm_parameter" "amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "a" {
  ami                    = data.aws_ssm_parameter.amzn2_ami.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.a_public_a.id
  vpc_security_group_ids = [aws_security_group.a.id]
  key_name               = "default"

  tags = {
    Name = "${var.app_name}-a"
  }

  lifecycle {
    ignore_changes = [iam_instance_profile, tags]
  }

  user_data = <<EOF
#!/bin/bash
echo hello
EOF
}

resource "aws_instance" "b" {
  ami                    = data.aws_ssm_parameter.amzn2_ami.value
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.b_public_a.id
  vpc_security_group_ids = [aws_security_group.b.id]
  key_name               = "default"

  tags = {
    Name = "${var.app_name}-b"
  }

  lifecycle {
    ignore_changes = [iam_instance_profile, tags]
  }

  user_data = <<EOF
#!/bin/bash
echo hello
EOF
}
