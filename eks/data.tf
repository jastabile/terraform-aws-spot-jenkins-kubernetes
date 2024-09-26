data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

data "aws_caller_identity" "current" {}