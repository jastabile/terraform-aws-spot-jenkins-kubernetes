module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.11.0"
  cluster_name    = "${var.prefix}${var.cluster_name}"
  cluster_version = "1.30"

  # Gives Terraform identity admin access to cluster which will
  # allow deploying resources (Karpenter) into the cluster
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }
  enable_irsa = true
  
  # node_security_group_tags = {
  #   "karpenter.sh/discovery" = var.cluster_name
  # }

  create_kms_key                = true
  kms_key_enable_default_policy = true
  cluster_encryption_config = {
    resources = ["secrets"]
  }
  kms_key_deletion_window_in_days = 7
  enable_kms_key_rotation         = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    disk_size                  = 50
    instance_types             = ["t3a.medium"]
    iam_role_attach_cni_policy = true
  }

  eks_managed_node_groups = {
    # Karpenter-migration
    critical-addons = {
      min_size     = 3
      max_size     = 3
      desired_size = 3

      instance_types = ["t3a.medium"]
      capacity_type  = "ON_DEMAND"

      labels = {
        name = "critical-addons"
      }

      taints = {
        dedicated = {
          key    = "CriticalAddonsOnly"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      }
      
      # TODO
      # block_device_mappings = {
      #   xvda = {
      #     device_name = "/dev/xvda"
      #     ebs = {
      #       volume_size           = 30
      #       volume_type           = "gp3"
      #       encrypted             = true
      #       kms_key_id            = aws_kms_key.ebs_volume.arn
      #       delete_on_termination = false
      #     }
      #   }
      # }
    }
  }

  tags = merge(var.tags, local.karpenter_discovery_tags)

  # aws_auth_roles = [
  #   {
  #     rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/openvpn-profile"
  #     username = "aws-openvpn-profile"
  #     groups   = ["system:masters"]
  #   },
  #   {
  #     rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/KarpenterNodeRole-${var.cluster_name}"
  #     username = "system:node:{{EC2PrivateDNSName}}"
  #     groups   = ["system:bootstrappers", "system:nodes"]
  #   },
  # ]


  kms_key_administrators = [for user in var.cluster_admin_users :
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${user}"
  ]

  # aws_auth_accounts = [data.aws_caller_identity.current.account_id]
}

module "eks_aws-auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "20.24.0"


  manage_aws_auth_configmap = true


  aws_auth_users = concat([{
    userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
    username = "aws-root"
    groups   = ["system:masters"]
    }], [for user in var.cluster_admin_users : {
    userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${user}"
    username = "aws-${user}"
    groups   = ["system:masters"] # TODO: granular access
  }])
}


module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "${var.cluster_name}-ebs-csi"
  attach_ebs_csi_policy = false

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

# EBS CSI Driver managed policy attach
resource "aws_iam_role_policy_attachment" "attach" {
  role       = module.ebs_csi_irsa_role.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

