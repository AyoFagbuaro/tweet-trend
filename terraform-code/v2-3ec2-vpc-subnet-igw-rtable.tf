provider "aws" {
  region = "eu-west-2"
  
}

resource "aws_instance" "demo-server" {
  ami           = "ami-091f18e98bc129c4e"
  instance_type = "t2.micro"
  key_name = "oyin"
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id = aws_subnet.demo-public-Subnet-01.id
  
  
  for_each = toset(["Jenkins-master", "Jenkins-slave", "Ansible"])
  tags = {
    Name = "${each.key}"

}
}

resource "aws_vpc" "demo-vpc"  {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "demo-vpc"
  }
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id      = aws_vpc.demo-vpc.id
  
  ingress {
    description      = "Shh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress {
    description      = "Jenkins port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-prot"

  }
}


resource "aws_subnet" "demo-public-Subnet-01" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "demo-public-Subnet-01"
  }
}

resource "aws_subnet" "demo-public-Subnet-02" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "demo-public-Subnet-02"
  }
}


resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo-IGW"
  }
}

resource "aws_route_table" "demo-public-route-table" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }
  tags =  {
    Name = "demo-public-route-table"
  }
}

resource "aws_route_table_association" "demo-public-route-table-association-01" {
  subnet_id      = aws_subnet.demo-public-Subnet-01.id
  route_table_id = aws_route_table.demo-public-route-table.id
}

resource "aws_route_table_association" "demo-public-route-table-association-02" {
  subnet_id      = aws_subnet.demo-public-Subnet-02.id
  route_table_id = aws_route_table.demo-public-route-table.id
}

