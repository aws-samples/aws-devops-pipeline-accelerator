/*# Backend must remain commented until the Bucket
 and the DynamoDB table are created. 
 After the creation you can uncomment it,
 run "terraform init" and then "terraform apply" */

terraform {
  backend "s3" {
    bucket         = "tf-state-dpa"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-dpa"
    encrypt        = false
  }
}