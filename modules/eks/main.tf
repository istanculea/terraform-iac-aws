module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = concat(var.public_subnet_ids, var.private_subnet_ids)

  # Managed node group configuration
  eks_managed_node_groups = {
    default = {
      desired_size   = var.desired_capacity
      min_size       = var.min_size
      max_size       = var.max_size
      instance_types = [var.instance_type]
    }
  }
}