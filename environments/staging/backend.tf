terraform {
  backend "s3" {
    bucket         = var.bucekt_name
    key            = var.bucket_key_path
    region         = var.region
    dynamodb_table = var.dynamodb_table
  }
}
