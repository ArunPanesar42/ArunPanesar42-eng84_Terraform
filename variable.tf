# creating variables to apply DRY using Terraform variable.tf
# These variables can be called in our main.tf


# # VPC
# variable "vpc_id" {
#   default = "vpc-08affaf5f68bdfbbc"
# }



# AMIs For Terraform
variable "webapp_ami_id" {
  default = "ami-0f852bb43834ab266"
}

variable "webdb_ami_id" {
  default = "ami-0fb639115a3aa1aae"
}



# Names
variable "aws_vpc" {
  default = "eng84_arun_terraform_vpc"
}

variable "webapp_ami" {
  default = "eng84_arun_terraform_app"
}

variable "db_name" {
  default = "eng84_arun_terraform_db"
}

variable "aws_subnet" {
  default = "eng84_arun_terraform_subnet"
}

variable "aws_subnet_private" {
  default = "eng84_arun_terraform_private_subnet"
}

variable "aws_igw"{
  default = "eng84_arun_terraform_igw"
}

variable "aws_public_rt"{
  default = "eng84_arun_terraform_rt_public"
}

variable "aws_private_rt"{
  default = "eng84_arun_terraform_rt_private"
}

variable "aws_public_sg"{
  default = "eng84_arun_terraform_public_sg"
}

variable "aws_private_sg"{
  default = "eng84_arun_terraform_private_sg"
}

# *********** IPs ******************

# 

variable "aws_vpc_cidr" {
  default = "21.21.0.0/16"
}

variable "aws_public_cidr" {
  default = "21.21.7.0/24"
}

variable "aws_private_cidr" {
  default = "21.21.8.0/24"
}

variable "my_ip"{
  default = "xxxx"
}

variable "webapp_ip"{
  default = "21.21.7.77"
}

variable "db_ip"{
  default = "21.21.8.888"
}



#************* Keys *************** 
variable "aws_key_name" {
  default = "eng84devops"
}

variable "aws_key_path" {
  default = "~/.ssh/eng84devops.pem"
}