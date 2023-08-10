module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.13"

  cluster_name                   = "demo"
  cluster_version                = "1.27"
  cluster_endpoint_public_access = true
  create_kms_key                 = false
  cluster_encryption_config      = {}

  cluster_enabled_log_types = [
    "audit",
    "api",
  ]

  vpc_id     = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.private-eu-central-1a.id,
    aws_subnet.private-eu-central-1b.id,
    aws_subnet.private-eu-central-1c.id,
  ]

  # Fargate profiles use the cluster primary security group so these are not utilized
  create_cluster_security_group = false
  create_node_security_group    = false
  create_cloudwatch_log_group   = false

  # cluster_endpoint_public_access_cidrs = [
  #   "***************",
  #   "***************",
  # ]

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::767728685280:role/AWSReservedSSO_PowerUserAccess_dev_btcturk_bf1816004d669858"
      username = "cluster-admin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::767728685280:role/AWSReservedSSO_AdministratorAccess_a26132fc7f5ea549"
      username = "cluster-admin"
      groups   = ["system:masters"]
    },
  ]

  eks_managed_node_groups = {
    traffic = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["m5.xlarge"]
      ami_type = "BOTTLEROCKET_x86_64"
      platform = "bottlerocket"

      labels = {
        dedicated = "traffic"
      }
    }
    singletons = {
      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["m5.xlarge"]
      ami_type = "BOTTLEROCKET_x86_64"
      platform = "bottlerocket"

      labels = {
        dedicated = "singletons"
      }      
      
      taints = [
        {
          key    = "dedicated"
          value  = "singletons"
          effect = "NO_SCHEDULE"
        }
      ]
    }
  }
}