# Infrastructure‑as‑Code Project with Terraform

This project demonstrates how to use **Terraform** to automate provisioning of cloud resources on AWS.  It follows the **Infrastructure‑as‑Code (IaC)** approach by codifying the network, compute and container orchestration layers in reusable modules.  The project is organised as a multi‑module Terraform configuration that can create a Virtual Private Cloud (VPC) with public/private subnets, deploy a simple EC2 instance and provision an Amazon Elastic Kubernetes Service (EKS) cluster.  The backend state is stored remotely in an S3 bucket with a DynamoDB table for state locking so that infrastructure changes are reproducible and collaborative.

## Why Terraform?

According to the HashiCorp documentation, Terraform provides a unified workflow that can manage the full life cycle of AWS infrastructure, automatically respecting dependencies between resources like VPCs and subnets【486009853591354†L137-L138】.  When integrated with automation tools such as Jenkins, Infrastructure‑as‑Code projects reduce manual provisioning time, enforce consistency and enable easy rollbacks via version‑controlled configuration【710810205939291†L1085-L1125】.  A Medium tutorial on building modular AWS environments emphasises breaking infrastructure into reusable modules for the VPC, compute and database layers to keep code clean and scalable【913845848517268†L61-L100】.  The same guide highlights the importance of using an S3 backend with a DynamoDB table to store and lock the Terraform state file so that multiple engineers can collaborate safely【913845848517268†L178-L215】.

## Project Structure

The repository is laid out with a root module that composes three sub‑modules:

```
iac-terraform/
├── backend.tf              # remote state backend configuration (S3 + DynamoDB)
├── main.tf                 # root module orchestrating sub‑modules
├── variables.tf            # input variables for the root module
├── outputs.tf              # outputs exported by the root module
├── providers.tf            # provider and Terraform version requirements
├── modules/
│   ├── vpc/
│   │   ├── main.tf         # defines VPC, public and private subnets
│   │   ├── variables.tf    # variables required by the VPC module
│   │   └── outputs.tf      # outputs (VPC ID, subnet IDs)
│   ├── ec2/
│   │   ├── main.tf         # provisions an EC2 instance and security group
│   │   ├── variables.tf    # variables for EC2 module
│   │   └── outputs.tf      # outputs the public IP of the instance
│   └── eks/
│       ├── main.tf         # wraps the official terraform‑aws‑eks module
│       ├── variables.tf    # variables for EKS module
│       └── outputs.tf      # outputs cluster name and endpoint
└── terraform.tfvars        # optional file to set real values for variables
```

### Remote State Backend

Before running any Terraform commands, create an S3 bucket and a DynamoDB table for state locking.  The Medium guide notes that a remote backend is crucial for collaborative, consistent and recoverable infrastructure【913845848517268†L178-L215】.  Update `terraform.tfvars` with your bucket name and DynamoDB table name:

```hcl
backend_bucket        = "your-terraform-state-bucket"
backend_dynamodb_table = "terraform-locks"
region                = "us-east-1"
ec2_key_name          = "my-key-pair"
ec2_ami_id            = "ami-0c02fb55956c7d316" # example Amazon Linux 2 AMI
```

## Deploying the Infrastructure

1. **Install Terraform** and ensure you have AWS credentials configured via environment variables or the AWS CLI.
2. **Create backend resources** (S3 bucket and DynamoDB table) if they don’t already exist.
3. Initialise the project:

   ```bash
   cd iac-terraform
   terraform init
   ```

4. Review the execution plan:

   ```bash
   terraform plan
   ```

5. Apply the configuration:

   ```bash
   terraform apply
   ```

Terraform will provision a VPC with public and private subnets, an EC2 instance in a public subnet and an EKS cluster spanning the subnets.  The outputs include the VPC ID, public IP of the EC2 instance and the EKS cluster endpoint.  When you are finished testing, destroy the infrastructure with `terraform destroy` to avoid ongoing charges.

## CI/CD Considerations

The project’s modular structure makes it easy to integrate into CI/CD pipelines.  A Jenkins pipeline can trigger `terraform plan` and `terraform apply` commands on every push.  The UpGrad article on Jenkins project ideas notes that combining Jenkins with Terraform automates infrastructure provisioning, reduces manual errors and allows version‑controlled rollbacks【710810205939291†L1085-L1125】.  You can extend this project by adding a `.github/workflows/terraform.yml` or Jenkinsfile to codify the pipeline.
