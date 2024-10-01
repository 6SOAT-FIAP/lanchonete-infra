resource "kubernetes_config_map" "aws-auth" {
  data = {
    "mapRoles" = <<EOT
- rolearn: arn:aws:iam::578360598759:role/role-adm
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
      # Therefore, before you specify rolearn, remove the path. For example, change arn:aws:iam::<123456789012>:role/<team>/<developers>/<eks-admin> to arn:aws:iam::<123456789012>:role/<eks-admin>. FYI:https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting_iam.html#security-iam-troubleshoot-ConfigMap
# Add as below
- rolearn: role-adm
  username: luhan
  groups: # REF: https://kubernetes.io/ja/docs/reference/access-authn-authz/rbac/
    - hoge
EOT
  }

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}