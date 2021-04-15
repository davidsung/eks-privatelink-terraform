data "aws_caller_identity" "consumer" {
  provider = aws.consumer
}

data "aws_availability_zones" "consumer_all" {
  provider = aws.consumer
}

module "consumer_vpc" {
  providers = {
    aws = aws.consumer
  }

  source = "terraform-aws-modules/vpc/aws"

  name = var.consumer_vpc_name
  cidr = var.consumer_vpc_cidr

  azs             = data.aws_availability_zones.consumer_all.names
  private_subnets = [cidrsubnet(var.consumer_vpc_cidr, 3, 0), cidrsubnet(var.consumer_vpc_cidr, 3, 1), cidrsubnet(var.consumer_vpc_cidr, 3, 2)]
  public_subnets  = [cidrsubnet(var.consumer_vpc_cidr, 3, 3), cidrsubnet(var.consumer_vpc_cidr, 3, 4), cidrsubnet(var.consumer_vpc_cidr, 3, 5)]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  enable_dns_hostnames = true

  tags = {
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "vpce" {
  provider     = aws.consumer

  vpc_id       = module.consumer_vpc.vpc_id
  service_name = aws_vpc_endpoint_service.sample.service_name
  vpc_endpoint_type = "Interface"

  subnet_ids   = module.consumer_vpc.private_subnets
  security_group_ids = [aws_security_group.vpce_sg.id]
}

resource "aws_security_group" "compute_sg" {
  provider = aws.consumer

  name   = "consumer_compute_sg"
  vpc_id = module.consumer_vpc.vpc_id

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group" "vpce_sg" {
  provider = aws.consumer

  name   = "consumer_vpce_sg"
  vpc_id = module.consumer_vpc.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [aws_security_group.compute_sg.id]
  }

  tags = {
    Environment = var.environment
  }
}

module "consumer_compute" {
  source = "./modules/ssm-ec2"

  providers = {
    aws = aws.consumer
  }

  subnet_id = module.consumer_vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.compute_sg.id]
}
