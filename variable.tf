# creating variables to apply DRY using Terraform variable.tf
# These variables can be called in our main.tf
######################################################################

# Creating variables to apply DRY using Terraform variable.tf
# These variables can be called in our main.tf

# AMI ###############################################################

variable "webapp_ami_id" {
  default = "ami-0f852bb43834ab266"
}

variable "db_ami_id" {
  default = "ami-0fb639115a3aa1aae"
}

# NAMES OF VARIABLES ###############################################

variable "aws_vpc" {
  default = "eng84_arun_terraform_vpc"
}

variable "aws_subnet_public" {
  default = "eng84_arun_terraform_public_subnet"
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

variable "aws_webapp" {
  default = "eng84_arun_terraform_webapp"
}

variable "aws_db" {
  default = "eng84_arun_terraform_db"
}

# IPs and CIDR #################################################

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
  default = "82.14.6.128/32"
}

variable "webapp_ip"{
  default = "21.21.7.77"
}

variable "db_ip"{
  default = "21.21.8.88"
}

# AWS KEY #######################################################

variable "key" {
  default = "eng84devops"
}

variable "key_path" {
  default = "~/.ssh/eng84devops.pem"
}