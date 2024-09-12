module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "${var.prefix}${var.vpc_name}"
  cidr = var.vpc_cidr

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  one_nat_gateway_per_az = true
  single_nat_gateway = false
  enable_dns_hostnames = true

  public_subnet_tags = merge(
    var.tags, 
    {"kubernetes.io/role/elb" = 1}, 
    local.karpenter_discovery_tags
  )
  private_subnet_tags = merge(
    var.tags, 
    {"kubernetes.io/role/internal-elb" = 1}, 
    local.karpenter_discovery_tags
  )


  tags = var.tags
}

module "vpc_cni_irsa" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name   = "vpc-cni"

  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = merge(var.tags, {
    Name = "vpc-cni-irsa"
  })
}

#TODO
# resource "aws_security_group" "pritunl_link" {
#   name = "${local.prefix}-pritunl-link"
#   vpc_id = module.vpc.vpc_id
#   ingress {
#     cidr_blocks = ["0.0.0.0/0"]
#     to_port = 9790
#     from_port = 9790
#     protocol = "TCP"
#     description = "host-check"
#   }
#   ingress {
#     cidr_blocks = ["172.22.0.0/24"]
#     to_port = 22
#     from_port = 22
#     protocol = "TCP"
#     description = "ssh-access"
#   }
#   ingress {
#     cidr_blocks = ["0.0.0.0/0"]
#     to_port = 500
#     from_port = 500
#     protocol = "UDP"
#     description = "ipsec"
#   }
#   ingress {
#     cidr_blocks = ["0.0.0.0/0"]
#     to_port = 4500
#     from_port = 4500
#     protocol = "UDP"
#     description = "ipsec"
#   }
#   ingress {
#     security_groups = [module.eks.node_security_group_id]
#     to_port = 0
#     from_port = 0
#     protocol = "-1"
#     description = "all-ingress-from-cluster"
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }

# resource "aws_security_group_rule" "node_vpcs_egress" {
#   cidr_blocks = ["198.21.0.0/16", "10.17.0.0/16"]
#   to_port = 0
#   from_port = 0
#   protocol = "TCP"
#   description = "vpcs-egress"
#   security_group_id = module.eks.node_security_group_id
#   type = "egress"
# }

resource "aws_security_group_rule" "cluster_to_nodegroups" {
  source_security_group_id = module.eks.cluster_security_group_id
  to_port = 0
  from_port = 0
  protocol = "all"
  description = "Accept traffic from self cluster"
  security_group_id = module.eks.node_security_group_id
  type = "ingress"
}

resource "aws_security_group_rule" "node_self_request" {
  source_security_group_id = module.eks.node_security_group_id
  to_port = 65535
  from_port = 0
  protocol = "TCP"
  description = "Allow nodes to request each other"
  security_group_id = module.eks.node_security_group_id
  type = "ingress"
}