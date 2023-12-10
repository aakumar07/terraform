provider "aws" {
  alias = "us-east-1"

  region = "us-east-1"
}

provider "aws" {
  alias = "us-east-2"

  region = "us-east-2"
}

module "us-east-1" {
    source = "/home/ec2-user/modules/us-east-1"
    vpc_cidr = "10.0.0.0/16"
    awspubsub_cidr = "10.0.1.0/24"
    awsprisub_cidr = "10.0.2.0/24"
    igw_cidr = "0.0.0.0/0"
}

module "us-east-2" {
    source = "/home/ec2-user/modules/us-east-2"
    vpc_cidr = "10.0.0.0/16"
    awspubsub_cidr = "10.0.1.0/24"
    awsprisub_cidr = "10.0.2.0/24"
    igw_cidr = "0.0.0.0/0"
}
