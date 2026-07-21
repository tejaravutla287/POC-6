module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "prime-poc-cluster"
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets # Keeps worker nodes inside the public layer

  cluster_endpoint_public_access           = true
  
  # CRITICAL FIX 1: Automatically injects your IAM User permissions into the cluster core database
  enable_cluster_creator_admin_permissions = true

  # CRITICAL FIX 2: Grants EKS permission to read and authenticate node security groups natively
  authentication_mode = "API_AND_CONFIG_MAP"

  eks_managed_node_groups = {
    monitoring_node = {
      min_size       = 1
      max_size       = 1
      desired_size   = 1
      instance_types = ["c7i-flex.large"]

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
