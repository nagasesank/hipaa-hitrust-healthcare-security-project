variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the healthcare workload VPC."
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone used for the cost-conscious Phase 2 lab deployment."
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public edge subnet."
  type        = string
}

variable "private_app_subnet_cidr" {
  description = "CIDR block for the private application subnet."
  type        = string
}

variable "private_data_subnet_cidr" {
  description = "CIDR block for the private data subnet."
  type        = string
}

variable "flow_log_retention_days" {
  description = "CloudWatch Logs retention period for VPC Flow Logs."
  type        = number
}