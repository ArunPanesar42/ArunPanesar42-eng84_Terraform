# Here is how we deploy our website with terraform 
# Our Provider is AWS
# This code will eventually launch an EC2 instance for us
# provider is a keyword in Terraform to define the name of cloud provider

# Syntax:
# Resource is the key word that allows us to add aws resource as task in application
# Resource block of code
# Let's initialise terraform
provider "aws"{
# define the region to launch the ec2 instance in Ireland 
  region = "eu-west-1"
}

# Creating a VPC
resource "aws_vpc" "arun_terraform_asg_vpc"{
 cidr_block = var.aws_vpc_cidr
 instance_tenancy = "default"

 tags = {
   Name = var.aws_vpc
 }
}

# Creating an internet gateway
resource "aws_internet_gateway" "arun_terraform_asg_igw" {
  vpc_id = aws_vpc.arun_terraform_asg_vpc.id

  tags = {
    Name = var.aws_igw
  }
}

# Editing the main Route Table
resource "aws_default_route_table" "arun_terraform_asg_rt_public" {
  default_route_table_id = aws_vpc.arun_terraform_asg_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.arun_terraform_asg_igw.id
  }

  tags = {
    Name = var.aws_public_rt
  }
}

# Creating our First Public Subnet 1, This will be Availability Zone 1
resource "aws_subnet" "arun_terraform_asg_public_subnet" {
  vpc_id = aws_vpc.arun_terraform_asg_vpc.id
  cidr_block = var.aws_public_cidr
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${var.aws_subnet_public}-1"
  }
}

# Creating our Second Public Subnet, This will be Availability Zone 2
resource "aws_subnet" "arun_terraform_asg_public_2_subnet" {
  vpc_id = aws_vpc.arun_terraform_asg_vpc.id
  cidr_block = var.aws_public_2_cidr
  availability_zone = "eu-west-1b"

  tags = {
    Name = "${var.aws_subnet_public}-2"
  }
}

# Creating our Final Public Subnet, This will be Availability Zone 1
resource "aws_subnet" "arun_terraform_asg_public_3_subnet" {
  vpc_id = aws_vpc.arun_terraform_asg_vpc.id
  cidr_block = var.aws_public_3_cidr
  availability_zone = "eu-west-1c"

  tags = {
    Name = "${var.aws_subnet_public}-3"
  }
}

# This is where we associate the main route table with our public subnets
resource "aws_route_table_association" "arun_terraform_asg_asoc1" {
  subnet_id = aws_subnet.arun_terraform_asg_public_subnet.id
  route_table_id = aws_vpc.arun_terraform_asg_vpc.default_route_table_id
}

resource "aws_route_table_association" "arun_terraform_asg_asoc2" {
  subnet_id = aws_subnet.arun_terraform_asg_public_2_subnet.id
  route_table_id = aws_vpc.arun_terraform_asg_vpc.default_route_table_id
}

resource "aws_route_table_association" "arun_terraform_asg_asoc3" {
  subnet_id = aws_subnet.arun_terraform_asg_public_3_subnet.id
  route_table_id = aws_vpc.arun_terraform_asg_vpc.default_route_table_id
}

# Creating a Private Route Table to help us keep track of paths
resource "aws_route_table" "arun_terraform_asg_rt_private" {
  vpc_id = aws_vpc.arun_terraform_asg_vpc.id

  tags = {
    Name = var.aws_private_rt
  }
}

# Creating our Private Subnet, This will be Availability Zone 1
resource "aws_subnet" "arun_terraform_asg_private_subnet" {
  vpc_id = aws_vpc.arun_terraform_asg_vpc.id
  cidr_block = var.aws_private_cidr
  availability_zone = "eu-west-1a"

  tags = {
    Name = "${var.aws_subnet_private}"
  }
}

# Associating private route table with private subnet
resource "aws_route_table_association" "arun_terraform_asg_asoc_priv" {
  subnet_id = aws_subnet.arun_terraform_asg_private_subnet.id
  route_table_id = aws_route_table.arun_terraform_asg_rt_private.id
}

# Creating security group for app
resource "aws_security_group" "arun_terraform_asg_public_sg" {
 name = var.aws_public_sg
 description = "App security group from Terraform"
 vpc_id = aws_vpc.arun_terraform_asg_vpc.id

 # Inbound rules for our app
 # Inbound rules code block:
 ingress {
  from_port = "80" # for our to launch in the browser
  to_port = "80" # for our to launch in the browser
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # allow all
 }

 ingress {
  from_port = "22"
  to_port = "22"
  protocol = "tcp"
  cidr_blocks = [var.my_ip]
  description = "Allow admin to SSH"
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

# Creating security group for db
resource "aws_security_group" "arun_terraform_asg_private_sg" {
  name = var.aws_private_sg
  description = "Db security group from Terraform"
  vpc_id = aws_vpc.arun_terraform_asg_vpc.id

  ingress {
    from_port         = "22"
    to_port           = "22"
    protocol          = "tcp"
    cidr_blocks       = [var.my_ip]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.arun_terraform_asg_public_sg.id]
    description = "Allow all traffic from the app"
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating DB instance
resource "aws_instance" "db_instance"{
  # add the AMI id between "" as below
  ami = var.db_ami_id

  # Let's add the type of instance we would like launch
  instance_type = "t2.micro"

  # Subnet
  subnet_id = aws_subnet.arun_terraform_asg_private_subnet.id

  private_ip = var.db_ip

  # Security group
  vpc_security_group_ids = [aws_security_group.arun_terraform_asg_private_sg.id]

  # Do we need to enable public IP for our app
  associate_public_ip_address = true

  key_name = var.key

  # Tags is to give name to our instance
  tags = {
    Name = "${var.aws_db}"
  }
}

# Creating the Application Load Balancer
resource "aws_lb" "arun_terraform_asg_load_balancer" {
  name               = "eng84-arun-terraform-alb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  security_groups    = [aws_security_group.arun_terraform_asg_public_sg.id]
  subnets            = [aws_subnet.arun_terraform_asg_public_subnet.id, aws_subnet.arun_terraform_asg_public_2_subnet.id, aws_subnet.arun_terraform_asg_public_3_subnet.id]
}

# Creating the target group:
resource "aws_lb_target_group" "arun_terraform_asg_target_group" {
  name     = "eng84-arun-terraform-tg-app"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.arun_terraform_asg_vpc.id
}

# Creating a listener
resource "aws_lb_listener" "arun_terraform_asg_listener" {
  load_balancer_arn = aws_lb.arun_terraform_asg_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.arun_terraform_asg_target_group.arn
  }

  depends_on = [aws_lb_target_group.arun_terraform_asg_target_group, aws_lb.arun_terraform_asg_load_balancer]
}

# Creating launch template for Auto Scaling Group
resource "aws_launch_template" "arun_terraform_asg_launch_template" {
  name          = "eng84_arun_terraform_autosg_lt"
  description = "template for web application"
  ebs_optimized = false
  image_id      = var.webapp_ami_id
  instance_type = "t2.micro"
  key_name = var.key

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination = true
    security_groups = [aws_security_group.arun_terraform_asg_public_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "eng84_arun_terraform_autosg_app"
    }
  }
  
  # The variable we have created called "user_data" allows us to launch 
  # provision/init file whenever we launch a new instance.
  user_data = filebase64("./Scripts/init.sh")
}

# This is where we create an Auto Scaling Group
resource "aws_autoscaling_group" "arun_terraform_auto_scaling_group" {
  name = "eng84_arun_terraform_autosg"
  desired_capacity = 3
  max_size         = 3
  min_size         = 3
  
  # Heath checks 
  health_check_grace_period = 250
  health_check_type         = "ELB"
  force_delete = true

  # Attaching load balancer in the form of a target group
  target_group_arns = [aws_lb_target_group.arun_terraform_asg_target_group.arn]

  vpc_zone_identifier = [aws_subnet.arun_terraform_asg_public_subnet.id, aws_subnet.arun_terraform_asg_public_2_subnet.id, aws_subnet.arun_terraform_asg_public_3_subnet.id]

  # Launching template so it runs the latest version and not old
  launch_template {
    id      = aws_launch_template.arun_terraform_asg_launch_template.id
    version = "$Latest"
  }

  depends_on = [aws_launch_template.arun_terraform_asg_launch_template]
}

# Resouce block of code ends here 

# terraform init
# terraform plan
# terraform apply
# terraform destroy