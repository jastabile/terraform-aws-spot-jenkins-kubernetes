# Description
This terraform creates a terraform cloud workspace and an AWS role to dynamically authenticate with AWS, so we can use terraform cloud state smoothly.

We just have to set the env variables for AWS and terraform cloud.
You can also change de example.tfvars file to your own preferences.

Important: the role created to authenticate Terraform cloud to AWS has Administrator access. To change this permissions remove `resource "aws_iam_role_policy_attachment" "admin"` in `aws.tf` file

# Steps
1- Set env variables 
```
export AWS_ACCESS_KEY_ID=<key_id>
export AWS_SECRET_ACCESS_KEY=<secret>
export TFE_TOKEN=<token_terraform_cloud>
```

2- Apply terraform
```
terraform plan -var-file=example.tfvars 
terraform apply -var-file=example.tfvars 
```

3- Set cloud configuration on any terraform to use it
```
terraform {
  cloud {
    organization = "sandbox-tfcloud-org"

    workspaces {
      name = "my-aws-workspace"
    }
  }
}
```