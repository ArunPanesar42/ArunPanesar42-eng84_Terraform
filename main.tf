# Let's initialise terraform
# Providers?
# AWS

# This code will eventually launch an EC2 instance for us

# provider is a keyword in Terraform to define the name of cloud provider


# Syntax:
# Resource is the key word that allows us to add aws resource as task in application
# Resource block of code
provider "aws"{
# define the region to launch the ec2 instance in Ireland
   region = "eu-west-1"
}



# Resource for vpc
resource "aws_vpc" "terraform_vpc_code_arun" {
	cidr_block = var.aws_vpc_cidr
	instance_tenancy = "default"

	tags = {
    	Name = var.aws_vpc
  	}
}



# Creates a internet gateway 
resource "aws_internet_gateway" "terraform_igw_arun" {
  vpc_id = aws_vpc.terraform_vpc_code_arun.id
  tags = {
      Name = "terraform_igw_arun"
    }
}



# Resource for public subnet
resource "aws_subnet" "terraform_pub_subnet_code_arun" {
  vpc_id = aws_vpc.terraform_vpc_code_arun.id
  cidr_block = "21.21.7.0/24"
  map_public_ip_on_launch = true //it makes this a public subnet
  availability_zone = "eu-west-1a"
  tags = {
    Name = "terraform_pub_subnet_code_arun"
    }
}

# Resource for private subnet
resource "aws_subnet" "terraform_priv_subnet_code_arun" {
  vpc_id = aws_vpc.terraform_vpc_code_arun.id
  cidr_block = "21.21.8.0/24"
  map_public_ip_on_launch = false //it makes this a private subnet
  availability_zone = "eu-west-1a"
  tags = {
    Name = "terraform_priv_subnet_code_arun"
    }
}




# Resource for Security group for our app
resource "aws_security_group" "terraform_sg_arun" {
  name = var.name
  description = "App Security Group"
  vpc_id = aws_vpc.terraform_vpc_code_arun.id
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    // This means, all ip address are allowed to ssh ! 
    // Do not do it in the production. 
    // Put your office or home address in it!
    cidr_blocks = ["0.0.0.0/0"]
    }

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["82.14.6.128/32"]
    description = "Allow admin to SSH"
    }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform_sg_arun"
  }
}
# Private
resource "aws_security_group" "terraform_priv_sg_arun" {
  name = "terraform_priv_sg_arun"
  description = "This is the SG I from my Terraform on Premise"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow all traffic from port 80 [HTTP]"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
      description = "Allow all Traffic to exit the vpc"
      from_port = 0
        to_port = 0
        protocol = "-1"  # Semantically equivelant to all
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "terraform_priv_sg_arun" 
  }
}



# create route tables 
resource "aws_route_table" "terraform_RT_arun" {
  vpc_id = aws_vpc.terraform_vpc_code_arun.id
    
    route {
      //associated subnet can reach everywhere
      cidr_block = "0.0.0.0/0" 
      //CRT uses this IGW to reach internet
      gateway_id = aws_internet_gateway.terraform_igw_arun.id 
    }
    
    tags = {
        Name = "terraform_RT_arun"
    }
}

# assign route tables
resource "aws_route_table_association" "terraform-pub-sub-RT"{
    subnet_id = aws_subnet.terraform_pub_subnet_code_arun.id
    route_table_id = aws_route_table.terraform_RT_arun.id
}

# Launch an EC2 Instance from our node_app AMI

resource "aws_instance" "app_instance"{
  ##first iteration for ami
  ## add the ami id between ""
  #ami = "ami-0f852bb43834ab266"

  # Second iteration 
  ami = var.webapp_ami_id

  # lets add instance type we would like to launch 
  instance_type = "t2.micro"

  # This would be used in old versions 
  #AWS_ACCESS_KEY:"" 
  #AWS_SECRET_KEY:""

  # Need to associate a public IP for our app
  associate_public_ip_address = true
  # Assigning a subnet
  subnet_id = aws_subnet.terraform_pub_subnet_code_arun.id

  # Security group
  vpc_security_group_ids = [aws_security_group.terraform_sg_arun.id]

  ## First iteration
  ## Tags are used to give a name to our instance
  #tags = {
    #Name = "eng84_arun_terraform_node_app"
  #}

  provisioner "file" {
    source      = "scripts/init.sh"
    destination = "/home/ubuntu/init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/init.sh",
      "sudo /home/ubuntu/init.sh"
    ]
  }

  connection {
    user        = "ubuntu"
    private_key = file(var.aws_key_path)
    host        = aws_instance.app_instance.public_ip
  }

  # Second Iteration 
  tags = {
    Name = var.name
  } 

  key_name = "eng84devops"
}

# Resouce block of code ends here 

# terraform init
# terraform plan
# terraform apply
# terraform destroy