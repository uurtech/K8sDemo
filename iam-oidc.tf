/*
This data block retrieves a TLS certificate from the specified URL, 
which is the OIDC issuer URL of the Amazon EKS cluster.
The url attribute is set to aws_eks_cluster.demo.identity[0].oidc[0].issuer, 
which fetches the OIDC issuer URL from the output of the data source representing the EKS cluster 
(aws_eks_cluster.demo).
*/
data "tls_certificate" "eks" {
  url = aws_eks_cluster.demo.identity[0].oidc[0].issuer
}

/*
The client_id_list attribute contains a list of client IDs that are allowed to authenticate with the OIDC provider. 
In this case, the only client ID specified is sts.amazonaws.com, which is necessary for 
EKS to authenticate itself with the OIDC provider.
*/
resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.demo.identity[0].oidc[0].issuer
}
