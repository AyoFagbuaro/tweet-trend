provider "aws" {
  region = "eu-west-2"
  
}

resource "aws_instance" "demo-server_sg" {
  ami           = "ami-091f18e98bc129c4e"
  instance_type = "t2.micro"
  key_name = "oyin"
  vpc_security_group_ids = [aws_security_group.demo_sg.id]
  subnet_id = aws_subnet.demo_sg-Subnet-01.id

}

resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "SSH access"
  vpc_id      = aws_vpc.demo_sg-vpc.id

  tags = {
    Name = "ssh-access"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_access_ipv4" {
  security_group_id = aws_security_group.demo_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}



resource "aws_vpc_security_group_egress_rule" "ssh_access_ipv4" {
  security_group_id = aws_security_group.demo_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc" "demo_sg-vpc"  {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "demo_sg-VPC"
  }
}


resource "aws_subnet" "demo_sg-Subnet-01" {
  vpc_id     = aws_vpc.demo_sg-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
    availability_zone = "eu-west-2a"

  tags = {
    Name = "demo_sg-Subnet-01"
  }
}

resource "aws_subnet" "demo_sg-Subnet-02" {
  vpc_id     = aws_vpc.demo_sg-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "demo_sg-Subnet-02"
  }
}

resource "aws_internet_gateway" "demo_sg-igw" {
  vpc_id = aws_vpc.demo_sg-vpc.id

  tags = {
    Name = "demo_sg-IGW"
  }
}

resource "aws_route_table" "demo_sg-public-route-table" {
  vpc_id = aws_vpc.demo_sg-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_sg-igw.id
  }
}

resource "aws_route_table_association" "demo_sg-public-route-table-association-01" {
  subnet_id      = aws_subnet.demo_sg-Subnet-01.id
  route_table_id = aws_route_table.demo_sg-public-route-table.id
}

resource "aws_route_table_association" "demo_sg-public-route-table-association-02" {
  subnet_id      = aws_subnet.demo_sg-Subnet-02.id
  route_table_id = aws_route_table.demo_sg-public-route-table.id
}

# 