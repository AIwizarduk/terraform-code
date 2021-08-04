# Purpose
Creating ap components such as load balancer, autoscaling group, aws waf, cloudfront and route 53

## Overview
This folder contains all the Terraform files necessary to create load balancer, autoscaling group, aws waf, cloudfront and route 53

# Author(s)
Farid Amirli

# How to deploy code
## Locally
pre-requisite:
- Terraform installed
- aws credentials file with up to date aws access keys with necessary permissions

Please clone this repo into your local machine and change directory into app. After that, run following commands by making sure that bucket name (already existing) is updated in ```env.backendconfig``` file so that terraform can store state file in that bucket:

```terraform init -backend-config=environments/dev/env.backendconfig```

Once done, run following command but also you should make sure that env.tfvars file is updated with right values from you AWS account

```terraform apply -auto-approve -var-file=environments//env/dev.tfvars```


## AWS Codepipeline
This repo optionally includes buildspec.yml file that will be read once you create AWS Codedeploy pipeline. Just make sure that source of your codepipeline is github (you will need to allow access aws app into your github), and make sure that value for environment TF_ACTION is either apply or destroy