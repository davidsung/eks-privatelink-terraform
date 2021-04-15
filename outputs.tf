# Output values
# Provider VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

# Provider EKS Cluster
output "eks_cluster_id" {
  value = module.eks.cluster_id
}

# Load Balancer and VPC Endpoint
output "lb_arn" {
  value = data.aws_lb.lb.arn
}

output "vpce_service_name" {
  value = aws_vpc_endpoint_service.sample.service_name
}

# Consumer VPC
output "consumer_vpc_id" {
  value = module.consumer_vpc.vpc_id
}

# Consumer EC2
output "consumer_compute_instance_id" {
  value = module.consumer_compute.instance_id
}
