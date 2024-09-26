variable "aws_region" {
  type = string
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


variable "cluster_name" {
  type = string
}