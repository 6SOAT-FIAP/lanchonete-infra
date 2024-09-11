resource "kubernetes_secret" "lanchonete_api_secret" {
  metadata {
    name      = "mongo-pass"
    namespace = kubernetes_namespace.lanchonete_api_ns.metadata.0.name
  }

  data = {
    mongo-root-password = "TBD"
    mongo-user-password = "TBD"
    environment         = "dev"
  }
}