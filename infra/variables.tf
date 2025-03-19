variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.0.1.0/24"
}

variable "ecr_repository_max_image_count" {
  description = "Controls the maximum number of images"
  type        = number
  default     = 10
}

variable "ecr_name" {
  description = "ECR name"
  type        = string
  default     = "my-ecr"
}

variable "ecs_cluster_cloud_watch_group_name" {
  description = "ECR name"
  type        = string
  default     = "/aws/ecs/my-cluster"
}

variable "ecs_cluster_name" {
  description = "ECS Cluster name"
  type        = string
  default     = "my-cluster"
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 3000
}

variable "acm_certificate_arn" {
  description = "ACM Certificate ARN"
  type        = string
  default     = "arn:aws:acm:us-east-1:123456789012:certificate/abcdefg1"
}

variable "container_name" {
  description = "ECS Cluster name"
  type        = string
  default     = "ecs-api"
}

variable "container_image" {
  description = "Container image in ECR"
  type        = string
  default     = "public.ecr.aws/ecs-api/ecs-api:latest"
}

variable "cpu" {
  description = "CPU"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Memory"
  type        = number
  default     = 1024
}

