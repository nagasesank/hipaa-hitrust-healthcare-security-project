locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Phase       = "02"
    Component   = "network"
  }
}

# ------------------------------------------------------------
# VPC
# ------------------------------------------------------------

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-vpc"
    }
  )
}

# ------------------------------------------------------------
# Internet Gateway
# ------------------------------------------------------------

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-igw"
    }
  )
}

# ------------------------------------------------------------
# Public Edge Subnet
# ------------------------------------------------------------

resource "aws_subnet" "public_edge" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-public-edge"
      Tier = "edge"
    }
  )
}

# ------------------------------------------------------------
# Private Application Subnet
# ------------------------------------------------------------

resource "aws_subnet" "private_app" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_app_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-private-app"
      Tier = "application"
    }
  )
}

# ------------------------------------------------------------
# Private Data Subnet
# ------------------------------------------------------------

resource "aws_subnet" "private_data" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_data_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-private-data"
      Tier = "data"
    }
  )
}

# ------------------------------------------------------------
# Public Edge Route Table
# ------------------------------------------------------------

resource "aws_route_table" "public_edge" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-public-edge-rt"
      Tier = "edge"
    }
  )
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public_edge.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_edge" {
  subnet_id      = aws_subnet.public_edge.id
  route_table_id = aws_route_table.public_edge.id
}

# ------------------------------------------------------------
# Private Application Route Table
# ------------------------------------------------------------

resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-private-app-rt"
      Tier = "application"
    }
  )
}

resource "aws_route_table_association" "private_app" {
  subnet_id      = aws_subnet.private_app.id
  route_table_id = aws_route_table.private_app.id
}

# ------------------------------------------------------------
# Private Data Route Table
# ------------------------------------------------------------

resource "aws_route_table" "private_data" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-private-data-rt"
      Tier = "data"
    }
  )
}

resource "aws_route_table_association" "private_data" {
  subnet_id      = aws_subnet.private_data.id
  route_table_id = aws_route_table.private_data.id
}

# ------------------------------------------------------------
# Security Group — Edge
# ------------------------------------------------------------

resource "aws_security_group" "edge" {
  name        = "${var.project_name}-${var.environment}-sg-edge"
  description = "Security group for the public edge tier."
  vpc_id      = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-sg-edge"
      Tier = "edge"
    }
  )
}

# ------------------------------------------------------------
# Security Group — Application
# ------------------------------------------------------------

resource "aws_security_group" "app" {
  name        = "${var.project_name}-${var.environment}-sg-app"
  description = "Security group for the private application tier."
  vpc_id      = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-sg-app"
      Tier = "application"
    }
  )
}

# ------------------------------------------------------------
# Security Group — Data
# ------------------------------------------------------------

resource "aws_security_group" "data" {
  name        = "${var.project_name}-${var.environment}-sg-data"
  description = "Security group for the private data tier."
  vpc_id      = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-sg-data"
      Tier = "data"
    }
  )
}

# ------------------------------------------------------------
# VPC Flow Logs
# ------------------------------------------------------------

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/${var.project_name}/${var.environment}/flow-logs"
  retention_in_days = var.flow_log_retention_days

  tags = local.common_tags
}

data "aws_iam_policy_document" "vpc_flow_logs_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "vpc_flow_logs" {
  name               = "${var.project_name}-${var.environment}-vpc-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs_assume_role.json

  tags = local.common_tags
}

data "aws_iam_policy_document" "vpc_flow_logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.vpc_flow_logs.arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "vpc_flow_logs" {
  name   = "${var.project_name}-${var.environment}-vpc-flow-logs-policy"
  role   = aws_iam_role.vpc_flow_logs.id
  policy = data.aws_iam_policy_document.vpc_flow_logs.json
}

resource "aws_flow_log" "this" {
  vpc_id                   = aws_vpc.this.id
  traffic_type             = "ALL"
  iam_role_arn             = aws_iam_role.vpc_flow_logs.arn
  log_destination          = aws_cloudwatch_log_group.vpc_flow_logs.arn
  max_aggregation_interval = 60

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-vpc-flow-logs"
    }
  )
}