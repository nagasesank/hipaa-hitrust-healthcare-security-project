output "patient_api_role_name" {
  description = "Name of the Patient API workload IAM role."
  value       = aws_iam_role.patient_api_workload.name
}

output "patient_api_role_arn" {
  description = "ARN of the Patient API workload IAM role."
  value       = aws_iam_role.patient_api_workload.arn
}

output "admin_api_role_name" {
  description = "Name of the Admin API workload IAM role."
  value       = aws_iam_role.admin_api_workload.name
}

output "admin_api_role_arn" {
  description = "ARN of the Admin API workload IAM role."
  value       = aws_iam_role.admin_api_workload.arn
}
