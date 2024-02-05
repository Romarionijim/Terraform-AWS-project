# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-bucket-rn-aws"
#     key            = "terraform-state-bucket-rn-aws/production/terraform.tfstate"
#     region         = "eu-west-1"
#     dynamodb_table = "dynamodb_state_lock_table"
#   }
# }
