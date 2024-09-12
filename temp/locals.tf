locals {
  karpenter_discovery_tags = {
    "karpenter.sh/discovery" = "${var.prefix}${var.cluster_name}"
  }
}