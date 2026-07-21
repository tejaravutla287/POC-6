module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "prime-poc-cluster"
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  
  # CRITICAL CHANGE: Launch nodes into public subnets to gain a true Public IP
  subnet_ids = module.vpc.public_subnets

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    monitoring_node = {
      min_size       = 1
      max_size       = 1
      desired_size   = 1
      instance_types = ["c7i-flex.large"]

      # CRITICAL CHANGE: Instructs AWS to assign a real Public IP on boot
      associate_public_ip_address = true

      iam_role_use_name_prefix = true
      iam_role_name            = "eks-node-poc-unique-role"
      
      iam_role_additional_policies = {
        AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      }
    }
  }
}
