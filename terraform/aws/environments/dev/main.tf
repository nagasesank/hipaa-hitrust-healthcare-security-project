module "network" {
  source = "../../modules/network"

  project_name = "careconnect-health"
  environment  = "dev"

  vpc_cidr                 = "10.20.0.0/16"
  availability_zone        = "ap-south-1a"
  public_subnet_cidr       = "10.20.1.0/24"
  private_app_subnet_cidr  = "10.20.10.0/24"
  private_data_subnet_cidr = "10.20.20.0/24"

  flow_log_retention_days = 7
}
module "iam" {
  source = "../../modules/iam"

  project_name = "careconnect-health"
  environment  = "dev"
}
