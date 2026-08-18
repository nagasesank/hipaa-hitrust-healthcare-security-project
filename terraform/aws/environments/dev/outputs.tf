output "vpc_id" {
  description = "ID of the healthcare workload VPC."
  value       = module.network.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the healthcare workload VPC."
  value       = module.network.vpc_cidr
}

output "public_edge_subnet_id" {
  description = "ID of the public edge subnet."
  value       = module.network.public_edge_subnet_id
}

output "private_app_subnet_id" {
  description = "ID of the private application subnet."
  value       = module.network.private_app_subnet_id
}

output "private_data_subnet_id" {
  description = "ID of the private data subnet."
  value       = module.network.private_data_subnet_id
}

output "edge_security_group_id" {
  description = "Security group ID for the edge tier."
  value       = module.network.edge_security_group_id
}

output "app_security_group_id" {
  description = "Security group ID for the application tier."
  value       = module.network.app_security_group_id
}

output "data_security_group_id" {
  description = "Security group ID for the data tier."
  value       = module.network.data_security_group_id
}

output "vpc_flow_log_id" {
  description = "ID of the VPC Flow Log."
  value       = module.network.vpc_flow_log_id
}

output "vpc_flow_log_group_name" {
  description = "CloudWatch Log Group receiving VPC Flow Logs."
  value       = module.network.vpc_flow_log_group_name
}