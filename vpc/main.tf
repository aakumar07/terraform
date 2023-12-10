provider "aws" {
    region = "us-eat-2"
}

module "vpc" {
    source = "./vpc/modules/vpc"
    vpc_cidr = "10.0.0.0/16"
    awspubsub_cidr = "10.0.1.0/24"
    awsprisub_cidr = "10.0.2.0/24"
    igw_cidr = "0.0.0.0/0"

}
