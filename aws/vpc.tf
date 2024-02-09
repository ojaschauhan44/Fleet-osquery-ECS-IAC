module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "fleet-vpc"
  #cidr = "10.10.0.0/16"
  cidr = "10.233.0.0/16"


  azs                 = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  private_subnets     = ["10.233.10.0/24", "10.233.11.0/24", "10.233.12.0/24"]
  public_subnets      = ["10.233.13.0/24", "10.233.14.0/24", "10.233.15.0/24"]
  database_subnets    = ["10.233.21.0/24", "10.233.22.0/24", "10.233.23.0/24"]
  elasticache_subnets = ["10.233.31.0/24", "10.233.32.0/24", "10.233.33.0/24"]

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  create_elasticache_subnet_group       = true
  create_elasticache_subnet_route_table = true

  enable_vpn_gateway     = false
  one_nat_gateway_per_az = false

  single_nat_gateway = true
  enable_nat_gateway = true
}