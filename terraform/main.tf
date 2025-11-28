provider "aws" {
  region = "eu-west-1"
}
 
# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
 
  tags = {
    Name = "agentic-ai-vpc"
  }
}
 
# Public Subnet 1
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
 
  tags = {
    Name = "agentic-ai-subnet-1"
  }
}
 
# Public Subnet 2
resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
 
  tags = {
    Name = "agentic-ai-subnet-2"
  }
}
 
# EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "agentic-ai-cluster"
  cluster_version = "1.29"
 
  vpc_id  = aws_vpc.main.id
  subnets = [
    aws_subnet.subnet1.id,
    aws_subnet.subnet2.id
  ]
 
  manage_aws_auth = true
 
  tags = {
    Environment = "dev"
    Project     = "agentic-ai"
  }
}
 
output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
