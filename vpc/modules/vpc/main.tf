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
    bucket = "myblks3"
}
