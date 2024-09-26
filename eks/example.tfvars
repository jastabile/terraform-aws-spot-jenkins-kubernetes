aws_region = "us-west-2"

vpc_name = "test-vpc"
vpc_cidr = "10.40.0.0/16"
private_subnets = ["10.40.0.0/19", "10.40.32.0/19"]
public_subnets  = ["10.40.128.0/19", "10.40.160.0/19"]


cluster_admin_users = ["develop-game"]
cluster_name = "test-cluster"