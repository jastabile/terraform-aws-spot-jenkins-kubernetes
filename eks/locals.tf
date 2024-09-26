locals {
  name   = "ex-${basename(path.cwd)}"

  tags = {
    Example = local.name
    env     = "test"
  }
}