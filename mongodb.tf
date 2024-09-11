resource "kubernetes_service" "lanchonete_api_mongo_service" {
  metadata {
    name      = "mongodb"
    namespace = kubernetes_namespace.lanchonete_api_ns.metadata.0.name
    labels    = {
      app = "lanchonete"
    }
  }

  spec {
    selector = {
      app  = kubernetes_deployment.lanchonete_api_mongo_deployment.metadata.0.labels.app
      tier = "mongodb"
    }

    port {
      port = 27017
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_persistent_volume_claim" "lanchonete_api_pvc" {
  metadata {
    name      = "mongodb-pvc"
    namespace = kubernetes_namespace.lanchonete_api_ns.metadata.0.name
    labels    = {
      app = "lanchonete"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "lanchonete_api_mongo_deployment" {
  metadata {
    name      = "mongodb"
    namespace = kubernetes_namespace.lanchonete_api_ns.metadata.0.name
    labels    = {
      app = "lanchonete"
    }
  }

  spec {
    selector {
      match_labels = {
        app  = "lanchonete"
        tier = "mongodb"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          app  = "lanchonete"
          tier = "mongodb"
        }
      }

      spec {
        container {
          image = "mongo"
          name  = "mongodb"

          #env {
          #            name = "MYSQL_DATABASE"
          #            value_from {
          #              config_map_key_ref {
          #                key  = "mysql-database-name"
          #                name = kubernetes_config_map.lanchonete_api_cm.metadata.0.name
          #
          #              }
          #            }
          #          }
          #
          #          env {
          #            name = "MYSQL_ROOT_PASSWORD"
          #            value_from {
          #              secret_key_ref {
          #                key  = "mysql-root-password"
          #                name = kubernetes_secret.lanchonete_api_secret.metadata.0.name
          #
          #              }
          #            }
          #          }
          #
          #          env {
          #            name = "MYSQL_USER"
          #            value_from {
          #              config_map_key_ref {
          #                key  = "mysql-user-username"
          #                name = kubernetes_config_map.lanchonete_api_cm.metadata.0.name
          #
          #              }
          #            }
          #          }
          #
          #          env {
          #            name = "MYSQL_PASSWORD"
          #            value_from {
          #              secret_key_ref {
          #                key  = "mysql-user-password"
          #                name = kubernetes_secret.lanchonete_api_secret.metadata.0.name
          #
          #              }
          #            }
          #          }

          liveness_probe {
            tcp_socket {
              port = 27017
            }
          }

          port {
            name           = "mongodb"
            container_port = 27017
          }

          volume_mount {
            name       = "mongodb-persistent-storage"
            mount_path = "/var/lib/mongodb"
          }
        }

        volume {
          name = "mongodb-persistent-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.lanchonete_api_pvc.metadata.0.name
          }
        }
      }
    }
  }
}