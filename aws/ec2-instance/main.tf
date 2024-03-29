provider "aws" {
    region = "us-east-2"
}

resource "aws_vpc" "myvpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "myvpc"
    }
}
resource "aws_subnet" "awspubsub" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-2a"
    cidr_block = var.awspubsub_cidr
    tags = {
        Name = "awspubsub"
    }
}
resource "aws_subnet" "awsprisub" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.awsprisub_cidr
    tags = {
        Name = "awsprisub"
    }
}
resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = "igw"
    }
}
resource "aws_route_table" "mainrt"{
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = var.igw_cidr
        gateway_id = aws_internet_gateway.igw.id
    }
}
resource "aws_route_table_association" "publicsubmet"{
    subnet_id = aws_subnet.awspubsub.id
    route_table_id = aws_route_table.mainrt.id
}
resource "aws_s3_bucket" "s3_bucket"{
    bucket = "myblks13"
}
resource "aws_instance" "this" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.awspubsub.id

    tags = {
      Name = "this"
    }
}
resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "TF_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}

resource "aws_security_group" "sg" {
  name        = "sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
  }

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg"
  }
}
