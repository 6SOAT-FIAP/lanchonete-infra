resource "kubernetes_service" "lanchonete_api_service" {
  metadata {
    name      = "lanchonete"
    namespace = kubernetes_namespace.lanchonete_api_ns.metadata.0.name
    labels    = {
      app = "lanchonete"
    }
  }

  spec {
    type     = "LoadBalancer"
    selector = {
      app = "lanchonete"
    }

    port {
      name        = "http"
      protocol    = "TCP"
      port        = 8080
      target_port = 8080
      node_port   = 30000
    }
  }
}


resource "kubernetes_deployment" "lanchonete_api_deployment" {
  metadata {
    name      = "lanchonete"
    namespace = kubernetes_namespace.lanchonete_api_ns.metadata.0.name
    labels    = {
      app = "lanchonete"
    }
  }


  spec {
    selector {
      match_labels = {
        app = "lanchonete"
      }
    }

    template {
      metadata {
        labels = {
          app = "lanchonete"
        }
      }

      spec {
        container {
          name              = "lanchonete"
          image             = "luhanlacerda/lanchonete-api:latest"
          image_pull_policy = "IfNotPresent"

          port {
            name           = "http"
            container_port = 8080
          }

          resources {
            limits = {
              cpu    = 0.2
              memory = "200Mi"
            }
          }

          env {
            name = "ENVIRONMENT"
            value_from {
              secret_key_ref {
                key  = "environment"
                name = kubernetes_secret.lanchonete_api_secret.metadata.0.name
              }
            }
          }

#          env {
#            name = "MONGODB_HOST"
#            value_from {
#              field_ref {
#                  field_path = kubernetes_service.lanchonete_api_mongo_service.spec[0].external_ips
#              }
#            }
#          }


        }
        image_pull_secrets {
          name = kubernetes_secret.lanchonete_api_secret.metadata.0.name
        }
      }
    }
  }
}