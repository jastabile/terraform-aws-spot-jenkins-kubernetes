prefix = "test-"

cluster_name = "cluster"
cluster_admin_users = ["develop-game"]

vpc_name = "vpc"
vpc_cidr = "10.40.0.0/16"
private_subnets = ["10.40.0.0/19", "10.40.32.0/19"]
public_subnets  = ["10.40.128.0/19", "10.40.160.0/19"]

tags = {
  "env" = "test"
}

aws_region = "us-west-2"


# karpenter_node_role_policies_arn = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
# shared_nodes_security_group      = "sg-0c1512a2caaf41896"


# TFC
# tfc_organization_name = "sandbox-tfcloud-org"
# tfc_project_name = "Example"