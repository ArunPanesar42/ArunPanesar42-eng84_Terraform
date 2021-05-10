# Terraform
## Terraform most used commands 
- terraform init
- terraform plan
- terraform apply
- terraform destroy
### Terraform to launch EC2 with VPC, subnets, SG services of AWS
```
provider "aws"{
   region = "eu-west-1"
}resource "aws_instance" "app_instance"{
	ami = "ami-0f852bb43834ab266"

	instance_type = "t2.micro"

	associate_public_ip_address = true

	tags = {
		Name = "eng84_arun_terraform_node_app"
	}
}

```
### Terraform installation and settings path in the env variable 
#### Sercuring AWS keys with Terraform 




