#If you want to create a new namespace, uncomment the code below
#resource "kubernetes_namespace" "lanchonete_api_namespace" {
#  metadata {
#    name = var.kubernetes_namespace
#  }
#}

resource "kubernetes_deployment" "deployment_lanchonete_api" {
  metadata {
    name      = var.cluster_name
    #    namespace = kubernetes_namespace.lanchonete_api_namespace.metadata.0.name
    namespace = var.kubernetes_namespace
  }

  spec {

    replicas = 2
    selector {
      match_labels = {
        app = var.cluster_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.cluster_name
        }
      }

      spec {
        // Prevent error:
        // 0/2 nodes are available: 2 node(s) were unschedulable.
        // preemption: 0/2 nodes are available: 2
        // Preemption is not helpful for scheduling.
        toleration {
          key    = "node-role.kubernetes.io/control-plane"
          effect = "NoSchedule"
        }
        restart_policy = "Always"
        container {
          name              = "lanchonete"
          image             = "luhanlacerda/lanchonete-api:latest"
          image_pull_policy = "Always"

          resources {
            #            requests = {
            #              cpu    = "2000m"
            #              memory = "2000m"
            #            }
            limits = {
              memory = "128Mi"
              cpu    = "500m"
            }
          }

          port {
            container_port = 8080
          }

          liveness_probe {
            http_get {
              path = "/swagger-ui/"
              port = 8080
            }
            initial_delay_seconds = 180
            period_seconds        = 3
          }

        }
      }
    }
  }

}

resource "kubernetes_service" "lanchonete_api_service" {
  metadata {
    name      = var.cluster_name
    #    namespace   = kubernetes_namespace.lanchonete_api_namespace.metadata.0.name
    namespace = var.kubernetes_namespace
    #    annotations = {
    #      "service.beta.kubernetes.io/aws-load-balancer-type" : "nlb",
    #      "service.beta.kubernetes.io/aws-load-balancer-scheme" : "internal",
    #      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" : "true"
    #    }
  }
  spec {
    selector = {
      app = "lanchonete-api"
    }
    port {
      port        = 8080
      target_port = 8080
      node_port   = 30000
    }
    type = "LoadBalancer"
  }
}
#
## Failed to create Ingress 'default/ingress-lanchonete-api' because: the server could not find the requested resource (post ingresses.extensions)
## So let's use kubernetes_ingress_v1 instead of kubernetes_ingress
#resource "kubernetes_ingress_v1" "lanchonete_api_ingress" {
#  metadata {
#    name      = "ingress-lanchonete-api"
#    #    namespace = kubernetes_namespace.lanchonete_api_namespace.metadata.0.name
#    namespace = var.kubernetes_namespace
#  }
#
#  spec {
#    default_backend {
#      service {
#        name = kubernetes_service.lanchonete_api_service.metadata[0].name
#        port {
#          number = kubernetes_service.lanchonete_api_service.spec[0].port[0].port
#        }
#      }
#    }
#  }
#}
#
#data "kubernetes_service" "lanchonete_api_service_data" {
#  metadata {
#    name      = kubernetes_service.lanchonete_api_service.metadata[0].name
#    namespace = kubernetes_service.lanchonete_api_service.metadata[0].namespace
#  }
#}