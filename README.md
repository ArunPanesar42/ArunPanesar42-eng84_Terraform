# Terraform
## What is Terraform
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

The key features of Terraform are:

- Infrastructure as Code: Infrastructure is described using a high-level configuration syntax. This allows a blueprint of your datacenter to be versioned and treated as you would any other code. Additionally, infrastructure can be shared and re-used.

- Execution Plans: Terraform has a "planning" step where it generates an execution plan. The execution plan shows what Terraform will do when you call apply. This lets you avoid any surprises when Terraform manipulates infrastructure.

- Resource Graph: Terraform builds a graph of all your resources, and parallelizes the creation and modification of any non-dependent resources. Because of this, Terraform builds infrastructure as efficiently as possible, and operators get insight into dependencies in their infrastructure.

- Change Automation: Complex changesets can be applied to your infrastructure with minimal human interaction. With the previously mentioned execution plan and resource graph, you know exactly what Terraform will change and in what order, avoiding many possible human errors.

## Benefits of Terraform 


## Terraform most used commands 
- `terraform init` = initialises Terraform with the dependencies of the provider mentioned in main.tf
- `terraform plan` = checks the syntax of the code and lists the jobs to be done (in main.tf)
- `terraform apply` = launches and executes the tasks in main.tf
- `terraform destroy` = destroys/terminates services running in main.tf


## Terraform Set-up 
These are the steps required to install terraform on a windows system!

### First things first, lets install
- We need to download terrform from the following website: https://www.terraform.io/downloads.html
- Then we extract terraform in a file path of our choice
- Next we need to go to windows settings to `Edit the system variables`
- Then edit the `User Varialbes` and add the path where terraform is installed and click `OK`
- For example i would add the path (e.g. C:\HashiCorp\Terraform)
- We can now check if its worked by going into our git bash and inputting `terraform --version`

### Now lets Sercure the AWS keys with Terraform 
- Go back to the `environment variables`
- Add two keys into the `User Variables` with the name `AWS_ACCESS_KEY` and `AWS_SECRET_KEY` and add your aws keys
- CLick `OK`

### Launching EC2 with VPC, subnets, SG services of AWS using Terraform 
In order to crearte EC2 intances with Terraform we need to create an dimplement code into a `main.tf` file.

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
## CI/CD Tools
![tools](https://github.com/ArunPanesar42/ArunPanesar42-eng84_Terraform/blob/main/Diagrams/CICD%20tools.png?raw=true)
## Clouds
There are many different types of clouds. 

### Public vs Private vs Hybrid Cloud
#### Diagram 
- Here is a diagram which shows thhe different types of clouds 
![cloud_diagram_ofeach](https://github.com/ArunPanesar42/ArunPanesar42-eng84_Terraform/blob/main/Diagrams/public-private-hybrid-clouds.png?raw=true)
#### Explaination 
- Here is an explaination for the dofference between clouds 

- ![explaination_clouds](https://github.com/ArunPanesar42/ArunPanesar42-eng84_Terraform/blob/main/Diagrams/public_private_hybrid_cloud.png?raw=true)

### Hybrid Cloud 

![hybrid_cloud](https://github.com/ArunPanesar42/ArunPanesar42-eng84_Terraform/blob/main/Diagrams/Hybrid%20clouds.jpg?raw=true)



