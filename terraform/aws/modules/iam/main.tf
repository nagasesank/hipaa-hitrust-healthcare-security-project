locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Phase       = "03"
    Component   = "iam"
  }
}

# ------------------------------------------------------------
# Patient API Workload Identity
# ------------------------------------------------------------

data "aws_iam_policy_document" "patient_api_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "patient_api_workload" {
  name               = "${var.project_name}-${var.environment}-patient-api-workload"
  assume_role_policy = data.aws_iam_policy_document.patient_api_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-patient-api-workload"
      Role = "patient-api-workload"
    }
  )
}

# ------------------------------------------------------------
# Admin API Workload Identity
# ------------------------------------------------------------

data "aws_iam_policy_document" "admin_api_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "admin_api_workload" {
  name               = "${var.project_name}-${var.environment}-admin-api-workload"
  assume_role_policy = data.aws_iam_policy_document.admin_api_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-admin-api-workload"
      Role = "admin-api-workload"
    }
  )
}
# ------------------------------------------------------------
# Patient API Workload Permissions
# ------------------------------------------------------------

data "aws_iam_policy_document" "patient_api_workload" {
  statement {
    sid    = "AllowApplicationAuditLogGroupCreation"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup"
    ]

    resources = [
      "*"
    ]
  }
 
  statement {
    sid    = "AllowApplicationAuditLogStreamWrite"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:log-group:/aws/careconnect-health/*:*"
    ]
  }
}

resource "aws_iam_role_policy" "patient_api_workload" {
  name   = "${var.project_name}-${var.environment}-patient-api-workload"
  role   = aws_iam_role.patient_api_workload.id
  policy = data.aws_iam_policy_document.patient_api_workload.json
}



# ------------------------------------------------------------
# Admin API Workload Permissions
# ------------------------------------------------------------

data "aws_iam_policy_document" "admin_api_workload" {
  statement {
    sid    = "AllowApplicationAuditLogging"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "AllowApplicationAuditLogStreamWrite"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:log-group:/aws/careconnect-health/*:*"
    ]
  }
}

resource "aws_iam_role_policy" "admin_api_workload" {
  name   = "${var.project_name}-${var.environment}-admin-api-workload"
  role   = aws_iam_role.admin_api_workload.id
  policy = data.aws_iam_policy_document.admin_api_workload.json
}
