terraform {
  cloud {
    organization = "sandbox-tfcloud-org"

    workspaces {
      name = "my-aws-workspace"
    }
  }
}