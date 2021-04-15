variable "environment" {
  type        = string
  description = "Environment"
  default     = "staging"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "ap-southeast-1"
}

// VPC
variable "vpc_name" {
  type        = string
  description = "VPC Name"
  default     = "vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}


// EKS
variable "cluster_prefix" {
  type = string
  default = "cluster"
  description = "EKS Cluster Prefix"
}

variable "cluster_version" {
  type = string
  default = "1.19"
  description = "EKS Version"
}

variable "instance_type" {
  type = string
  default = "m5.large"
  description = "Managed Node Group Instance Type"
}

variable "capacity_type" {
  type = string
  default = "ON_DEMAND"
  description = "Managed Node Group Capacity Type"
}

// Consumer
variable "consumer_profile" {
  type = string
  description = "AWS Consumer Profile Name"
}

variable "consumer_vpc_name" {
  type        = string
  description = "Consumer VPC Name"
  default     = "consumer_vpc"
}

variable "consumer_vpc_cidr" {
  type        = string
  description = "Consumer VPC CIDR block"
  default     = "10.1.0.0/16"
}
