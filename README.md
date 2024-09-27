# Introduction
This template create an EKS cluster with spot instances managed by karpenter and installs Jenkins configured to use pods as an agent that lives only for the time the job is being executed.

The cluster is created enabling IRSA to allow the use of IAM roles directly from pods.


# State in Terraform cloud 
If you want to have state in terraform cloud, there is a terraform to creaate a terraform organization and project in the `terraform-cloud` dir, ready to apply. 
Follow the instructions in `terraform-cloud/README.md`.

# EKS deploy
To deploy a new EKS with spot instances managed by karpenter follow instructions in `eks/README.md`.

# Ingress deploy
`ingress/` folder provides an example to install nginx ingress controller and a cloudflare tunnel to avoid exposing eks cluster to internet. Cloudflare tunnel connects securely to cloudflare network and you can define a DNS record in Cloudflare pointing to the tunnel to be used as the hostname.

# Jenkins deploy
`jenkins/` folder provides the configuration and steps to deploy jenkins on EKS with agents running on pods.


# Clean
To remove all the resources created:
```
helm delete jenkins -n jenkins
helm delete ingress-nginx -n ingress-nginx
terraform destroy -var-file=example.tfvars
```


