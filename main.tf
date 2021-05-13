# Here is how we deploy our website with terraform 
# Our Provider is AWS
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
# Create a VPC
resource "aws_vpc" "arun_terraform_vpc"{
 cidr_block = var.aws_vpc_cidr
 instance_tenancy = "default"

 tags = {
   Name = var.aws_vpc
 }
}


# Create an internet gateway
resource "aws_internet_gateway" "arun_terraform_igw" {
  vpc_id = aws_vpc.arun_terraform_vpc.id

  tags = {
    Name = var.aws_igw
  }
}


# Editing the main Route Table
resource "aws_default_route_table" "arun_terraform_rt_public" {
  default_route_table_id = aws_vpc.arun_terraform_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.arun_terraform_igw.id
  }

  tags = {
    Name = var.aws_public_rt
  }
}
# Creating Private Route Table
resource "aws_route_table" "arun_terraform_rt_private" {
  vpc_id = aws_vpc.arun_terraform_vpc.id

  tags = {
    Name = var.aws_private_rt
  }
}


# Create and assign a subnet to the VPC
# Public
resource "aws_subnet" "arun_terraform_public_subnet" {
  vpc_id = aws_vpc.arun_terraform_vpc.id
  cidr_block = var.aws_public_cidr
  availability_zone = "eu-west-1a"

  tags = {
    Name = var.aws_subnet_public
  }
}
# Private
resource "aws_subnet" "arun_terraform_private_subnet" {
  vpc_id = aws_vpc.arun_terraform_vpc.id
  cidr_block = var.aws_private_cidr
  availability_zone = "eu-west-1a"

  tags = {
    Name = var.aws_subnet_private
  }
}


# Associate route tables with both subnets (Public and Private)
resource "aws_route_table_association" "arun_terraform_asoc1" {
  subnet_id = aws_subnet.arun_terraform_public_subnet.id
  route_table_id = aws_vpc.arun_terraform_vpc.default_route_table_id
}
resource "aws_route_table_association" "arun_terraform_asoc2" {
  subnet_id = aws_subnet.arun_terraform_private_subnet.id
  route_table_id = aws_route_table.arun_terraform_rt_private.id
}


# Security group for app
resource "aws_security_group" "arun_terraform_public_sg" {
 name = var.aws_public_sg
 description = "app security group"
 vpc_id = aws_vpc.arun_terraform_vpc.id

 # Inbound rules for our app
 # Inbound rules code block:
 ingress {
  from_port = "80" # for our to launch in the browser
  to_port = "80" # for our to launch in the browser
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # allow all
 }
 # Inbound rules code block ends

 # Outbound rules code block
 egress{
  from_port = 0
  to_port = 0
  protocol = "-1" # allow all
  cidr_blocks = ["0.0.0.0/0"]
 }

 # Outbound rules code block ends
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
  security_group_id = aws_security_group.arun_terraform_public_sg.id
}

# Security group for db
resource "aws_security_group" "arun_terraform_private_sg" {
  name = var.aws_private_sg
  description = "db security group"
  vpc_id = aws_vpc.arun_terraform_vpc.id

  ingress {
    from_port         = "22"
    to_port           = "22"
    protocol          = "tcp"
    cidr_blocks       = [var.my_ip]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "app_access" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.aws_public_cidr]
  security_group_id = aws_security_group.arun_terraform_private_sg.id
}

# Creating DB instance
resource "aws_instance" "db_instance"{
  # add the AMI id between "" as below
  ami = var.db_ami_id

  # Let's add the type of instance we would like launch
  instance_type = "t2.micro"

  # Subnet
  subnet_id = aws_subnet.arun_terraform_private_subnet.id

  private_ip = var.db_ip

  # Security group
  vpc_security_group_ids = [aws_security_group.arun_terraform_private_sg.id]

  # Do we need to enable public IP for our app
  associate_public_ip_address = true

  key_name = var.key

  # Tags is to give name to our instance
  tags = {
    Name = var.aws_db
  }
}

# Creating APP instance
resource "aws_instance" "app_instance"{
  # add the AMI id between "" as below
  ami = var.webapp_ami_id

  # Let's add the type of instance we would like launch
  instance_type = "t2.micro"

  # Subnet
  subnet_id = aws_subnet.arun_terraform_public_subnet.id

  private_ip = var.webapp_ip

  # Security group
  vpc_security_group_ids = [aws_security_group.arun_terraform_public_sg.id]

  # Do we need to enable public IP for our app
  associate_public_ip_address = true

  key_name = var.key

  # Tags is to give name to our instance
  tags = {
    Name = var.aws_webapp
  }

  provisioner "file" {
    source      = "./scripts/init.sh"
    destination = "/home/ubuntu/init.sh"
  }

  # Change permissions on bash script and execute.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/init.sh",
      "bash /home/ubuntu/init.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.key_path)
    host        = self.public_ip
  }

  depends_on = [aws_instance.db_instance]
}


# Resouce block of code ends here 

# terraform init
# terraform plan
# terraform apply
# terraform destroy