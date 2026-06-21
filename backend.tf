 terraform {
   backend "s3" {
     bucket         = "daria-levchuk-tf-state-2026" 
     key            = "lesson-7/terraform.tfstate"
     region         = "us-east-1"
     dynamodb_table = "terraform-locks"
     encrypt        = true
   }
 }