terraform {
  cloud {
    organization = "test-tfcloud-org"

    workspaces {
      name = "my-aws-workspace"
    }
  }
}