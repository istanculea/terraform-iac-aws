module "vpc" {
  source               = "./modules/vpc"
  cidr_block           = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  project              = "iac-project"
}

module "ec2" {
  source      = "./modules/ec2"
  vpc_id      = module.vpc.vpc_id
  subnet_id   = module.vpc.public_subnet_ids[0]
  ami_id      = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  key_name    = var.ec2_key_name
  allowed_ssh_cidr_blocks = ["0.0.0.0/0"]
  project     = "iac-project"
}

module "eks" {
  source            = "./modules/eks"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  cluster_name       = var.cluster_name
  cluster_version    = "1.29"
  desired_capacity   = var.eks_desired_capacity
  min_size           = var.eks_min_size
  max_size           = var.eks_max_size
  instance_type      = var.eks_instance_type
}