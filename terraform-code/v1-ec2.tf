provider "aws" {
  region = "eu-west-2"
  
}

resource "aws_instance" "demo-server_sg" {
  ami           = "ami-091f18e98bc129c4e"
  instance_type = "t2.micro"
  key_name = "oyin"
  security_groups = [demo_sg]
}

resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "SSH access"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ssh-access"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_access_ipv4" {
  security_group_id = aws_security_group.demo_sg.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}



resource "aws_vpc_security_group_egress_rule" "ssh_access_ipv4" {
  security_group_id = aws_security_group.demo_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# 