resource "kubernetes_secret" "docker_secret" {
  metadata {
    name      = "docker-cfg"
    namespace = kubernetes_namespace.lanchonete_api_ns.metadata.0.name
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.registry_server}" = {
          auth = base64encode("${var.registry_username}:${var.registry_password}")
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}