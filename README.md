
# Terraform-AWS-Project
Deploy simple node-express app to AWS ECS using Fargate




## Pre requisites
* This project uses route53 so you need to own your own domain and provide it's value in the terraform.tfvars
* you need to create terraform.tfvars file in each environment directory and provide your own actual values (more explanation on this in the variables section)
* terraform installed (explained in the getting started section)
* AWS account (this project uses free tier eligible resources)
## Project Description
* This is a basic terraform project that spins up a simple dockerized nodejs-express app on multiple environments using ECS service on Fargate.
* The infrastructure was developed using Terraform modules on AWS.
* the project is configured to use Route53 for DNS and an application load balancer to route traffic and forward requests from the load balancer to the ECS service. 

## Getting Started 
* To get started with the project, you'll need to clone it to your machine using the following command:
* `git clone https://github.com/Romarionijim/Terraform-AWS-project.git`
* after cloning the project you need to install Terraform:
    
    * MacOS (HomeBrew):
        * `brew tap hashicorp/tap`
        * `brew install hashicorp/tap/terraform`
        * `brew update`
        * `brew upgrade hashicorp/tap/terraform`
    * Windows via Chocolatey (make sure you have Chocolatey installed):
        * `choco install terraform`
* Validate the installation by running:
    * `terraform -help`
    * you should be able to see the terraform commands
* Initialize Terraform, open your terminal where the project is located at and type:
    * `terraform init`
* Since there are 3 different environments directories -  in order to spin up one or more environment you need to cd to the relevant environment dir (dev, staging or prod) and run `terraform init`.
## Remote Backend
* In this project you can have a remote backend using S3 and DynamoDB
* In each environment directory you a `backend.tf` file
* In order to initialize the remote backend - cd to the relevant environment that you wanna spin up
* open the backend.tf file and uncomment the code
* open terminal and type `terraform init` and enter - this will create the remote backend for you on s3 to manage terraform state remotely using dynamodb for locking mechanism
## Variable values (terraform.tfvars)
* The actual values that are configured in this project that are stored in the terraform.tfvars file are part of gitignore since they store sensitive actual values.
* in order for this project to work and spin up the app on ECS using terraform - you need to provide your own AWS actual values based on the variable names that are provided in the variable.tf configurations.
* in order to do that - you need to create a terraform.tfvars file in each environment directory and provide your actual values in AWS.
## Applying resources and spinning up environments
* To sping up a specific environment - you need to cd to the envrionment directory (and after running terraform init as written in the getting started section) you need to tpy the following commands in the terminal:
    * `terraform plan` (you'll see the end result of what is declared in the config and validate that everything is planned accordinly)
    * `terraform apply -auto-approve`
## Destroy resources
* after applying resources and spinning up environments - DON'T forget to destory all the resources in order to not get billed for exceeding the use of certain recourses by running the following command in the terminal:
 * `terraform destroy -auto-approve`
