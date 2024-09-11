resource "kubernetes_config_map" "lanchonete_api_cm" {
  metadata {
    name      = "mongo-config-map"
    namespace = kubernetes_namespace.lanchonete_api_ns.metadata.0.name
  }

  ##TODO remover?
  data = {
    environment         = "dev"
  }
}