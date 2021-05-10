# Let's initialise terraform
# Providers?
# AWS

# This code will eventually launch an EC2 instance for us

# provider is a keyword in Terraform to define the name of cloud provider


# Syntax:

provider "aws"{
# define the region to launch the ec2 instance in Ireland
   region = "eu-west-1"
}

# Launch an EC2 Instance from our node_app AMI
# Resource is the key word that allows us to add aws resource as task in application
# Resource block of code

resource "aws_instance" "app_instance"{
	# add the ami id between ""
	ami = "ami-0f852bb43834ab266"

	# lets add instance type we would like to launch 
	instance_type = "t2.micro"

	# This would be used in old versions 
	#AWS_ACCESS_KEY:"" 
	#AWS_SECRET_KEY:""

	# Need to associate a public IP for our app
	associate_public_ip_address = true
	# Tags are used to give a name to our instance
	tags = {
		Name = "eng84_arun_terraform_node_app"
	}

	key_name = "eng84devops"
}

# Resource for vpc
resource "aws_default_vpc" "default" {
	#cidr_block = "10.0.0.0/16"
	#instance_tenancy = "default"

	tags = {
    	Name = "eng84_arun_terraform_VPC"
  	}
}

# Resouce block of code ends here 

# terraform init
# terraform plan
# terraform apply
# terraform destroy