output "vpc_id" {
  description = "ID of the healthcare workload VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR block of the healthcare workload VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_edge_subnet_id" {
  description = "ID of the public edge subnet."
  value       = aws_subnet.public_edge.id
}

output "private_app_subnet_id" {
  description = "ID of the private application subnet."
  value       = aws_subnet.private_app.id
}

output "private_data_subnet_id" {
  description = "ID of the private data subnet."
  value       = aws_subnet.private_data.id
}

output "edge_security_group_id" {
  description = "Security group ID for the edge tier."
  value       = aws_security_group.edge.id
}

output "app_security_group_id" {
  description = "Security group ID for the application tier."
  value       = aws_security_group.app.id
}

output "data_security_group_id" {
  description = "Security group ID for the data tier."
  value       = aws_security_group.data.id
}

output "vpc_flow_log_id" {
  description = "ID of the VPC Flow Log."
  value       = aws_flow_log.this.id
}

output "vpc_flow_log_group_name" {
  description = "CloudWatch Log Group receiving VPC Flow Logs."
  value       = aws_cloudwatch_log_group.vpc_flow_logs.name
}