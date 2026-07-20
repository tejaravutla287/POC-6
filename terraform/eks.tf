module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "prime-poc-cluster"
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    monitoring_node = {
      min_size       = 1
      max_size       = 1
      desired_size   = 1
      instance_types = ["c7i-flex.large"] # Fits application + ArgoCD + Helm Monitoring
    }
  }
}
