resource "aws_iam_role" "nodes" {
  name = "eks-node-group-nodes"
  /* 
  The assume_role_policy attribute specifies the permissions that entities 
  (in this case, EC2 instances) are allowed to assume this role. 
  In this configuration, EC2 instances can assume this role to interact with other AWS services.
  */
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

/* These resources attach existing AWS managed policies to the IAM role created in the previous step.
AmazonEKSWorkerNodePolicy: Provides permissions required by worker nodes in an Amazon EKS cluster 
to communicate with the control plane and other AWS services.
AmazonEKS_CNI_Policy: Grants required permissions for the Amazon VPC CNI plugin used 
by Amazon EKS nodes to operate in your VPC.
AmazonEC2ContainerRegistryReadOnly: Provides read-only access to Amazon Elastic Container Registry (ECR) for worker nodes.
*/
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "private-nodes"

  # The node group will use the IAM role
  node_role_arn   = aws_iam_role.nodes.arn

  # The node group will be launched in private subnets defined by their IDs 
  subnet_ids = [
    aws_subnet.private-eu-central-1a.id,
    aws_subnet.private-eu-central-1b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}

# resource "aws_launch_template" "eks-with-disks" {
#   name = "eks-with-disks"

#   key_name = "local-provisioner"

#   block_device_mappings {
#     device_name = "/dev/xvdb"

#     ebs {
#       volume_size = 50
#       volume_type = "gp2"
#     }
#   }
# }
