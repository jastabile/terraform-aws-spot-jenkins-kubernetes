# Preconfiguration
I'm using terraform cloud to store the state. In order to make it work:
- Using terraform cloud: change the values of `cloud.organization` and `cloud.workspaces.name` in `state.tf` file to your owns.
- Not using terraform cloud: remove `state.tf` file and configure completely to use another way, local or s3 for example.

Change the `example.tfvars` file values to the one you want


# Installation
To deploy you need to set your env vars for aws: 
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```
In case you're using Terraform cloud: 
- Dynamic credentials: run `terraform login` locally and follow the steps
- Static credentials: set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` [as environment variables in terraform cloud](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-create-variable-set) 

then run the following commands:
```
terraform plan -var-file=example.tfvars
terraform apply -var-file=example.tfvars
```

# Getting EKS credentials
```
aws eks update-kubeconfig --name <CLUSTER_NAME>
```
check if you're connected 


## Node pools
To add more node pools create more resources "kubectl_manifest" "karpenter_node_pool" as in `karpenter.tf` file
