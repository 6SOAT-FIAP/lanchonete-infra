resource "kubernetes_secret" "secret_lanchonete" {
  metadata {
    name = "secret-lanchonete"
  }

  type = "Opaque"

  data = {
    APPLICATION_VERSION          = var.image_version
    APPLICATION_DATABASE_VERSION = "latest"
    APPLICATION_PORT             = var.app_port
    SPRING_DATASOURCE_USERNAME   = var.db_username
    SPRING_DATASOURCE_PASSWORD   = var.db_password
    ENABLE_FLYWAY                = false
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "kubernetes_config_map" "cm_lanchonete" {
  metadata {
    name = "cm-lanchonete"
  }

  # TODO: Quando tivermos as configurações de banco, precisamos adaptar aqui
  data = {
    SPRING_DATASOURCE_URL = "jdbc:mysql://${var.db_host}:3306/${var.db_name}"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "kubernetes_deployment" "deployment_lanchonete_app" {
  metadata {
    name      = "deployment-lanchonete-app"
    namespace = "default"
  }

  spec {
    selector {
      match_labels = {
        app = "deployment-lanchonete-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "deployment-lanchonete-app"
        }
      }

      spec {
        // Prevent error:
        // 0/2 nodes are available: 2 node(s) were unschedulable.
        // preemption: 0/2 nodes are available: 2
        // Preemption is not helpful for scheduling.
        toleration {
          key      = "key"
          operator = "Equal"
          value    = "value"
          effect   = "NoSchedule"
        }

        container {
          name  = "deployment-lanchonete-app-container"
          image = "${var.image_username}/${var.image_name}:${var.image_version}"

          resources {
            requests = {
              memory : "512Mi"
              cpu : "500m"
            }
            limits = {
              memory = "1Gi"
              cpu    = "1"
            }
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.cm_lanchonete.metadata[0].name
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.secret_lanchonete.metadata[0].name
            }
          }

          port {
            container_port = var.app_port
          }

          # liveness_probe {
          #   http_get {
          #     path = "/api/v2/health-check"
          #     port = var.app_port
          #   }
          #   initial_delay_seconds = 30
          #   period_seconds        = 3
          # }
        }
      }
    }
  }

  depends_on = [aws_eks_node_group.lanchonete_node_group]
}

resource "kubernetes_service" "lanchonete_app_service" {
  metadata {
    name      = "service-lanchonete-app"
    namespace = "default"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" : "nlb",
      "service.beta.kubernetes.io/aws-load-balancer-scheme" : "internal",
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" : "true"
    }
  }
  spec {
    selector = {
      app = "deployment-lanchonete-app"
    }
    port {
      port        = var.app_port
      target_port = var.app_port
    }
    type = "LoadBalancer"
  }
}

# Failed to create Ingress 'default/ingress-lanchonete-app' because: the server could not find the requested resource (post ingresses.extensions)
# So let's use kubernetes_ingress_v1 instead of kubernetes_ingress
resource "kubernetes_ingress_v1" "lanchonete_app_ingress" {
  metadata {
    name      = "ingress-lanchonete-app"
    namespace = "default"
  }

  spec {
    default_backend {
      service {
        name = kubernetes_service.lanchonete_app_service.metadata[0].name
        port {
          number = kubernetes_service.lanchonete_app_service.spec[0].port[0].port
        }
      }
    }
  }
}

data "kubernetes_service" "lanchonete_app_service_data" {
  metadata {
    name      = kubernetes_service.lanchonete_app_service.metadata[0].name
    namespace = kubernetes_service.lanchonete_app_service.metadata[0].namespace
  }
}