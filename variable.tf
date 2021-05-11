# creating variables to apply DRY using Terraform variable.tf
# These variables can be called in our main.tf

variable "vpc_id" {
  default = "vpc-08affaf5f68bdfbbc"
}

variable "name" {
  default = "eng84_arun_terraform_variable"
}

variable "webapp_ami_id" {
  default = "ami-0f852bb43834ab266"
}

variable "aws_subnet" {
  default = "eng84_arun_terraform_subnet"
}

variable "aws_key_name" {
  default = "eng84devops"
}

variable "aws_key_path" {
  default = "~/.ssh/eng84devops.pem"
}