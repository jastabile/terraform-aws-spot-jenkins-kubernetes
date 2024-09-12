variable "aws_region" {
type = string
}

variable "prefix" {
  type = string
  default = "test"
}

variable "cluster_name" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
  description = "List of tags for every resource created"
}


variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}


variable "cluster_admin_users" {
  type = list(string)
  default = []
  description = "List of users from aws iam to access the cluster"
}


#TODO
# Karpenter-migration
# variable "account_id" {
#   type        = string
#   description = "AWS account ID"
# }

#TODO
# Karpenter-migration
# variable "karpenter_node_role_policies_arn" {
#   type        = set(string)
#   description = "AWS policy to attach"
# }
# variable "shared_nodes_security_group" {
#   type        = string
#   description = "shared_nodes_security_group"
# }



# TFC
variable "tfc_aws_audience" {
  type        = string
  default     = "aws.workload.identity"
  description = "The audience value to use in run identity tokens"
}

variable "tfc_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the TFC or TFE instance you'd like to use with AWS"
}

# variable "tfc_organization_name" {
#   type        = string
#   description = "The name of your Terraform Cloud organization"
# }

# variable "tfc_project_name" {
#   type        = string
#   default     = "Default Project"
#   description = "The project under which a workspace will be created"
# }

variable "tfc_workspace_name" {
  type        = string
  default     = "my-aws-workspace"
  description = "The name of the workspace that you'd like to create and connect to AWS"
}