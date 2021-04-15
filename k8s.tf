resource "kubernetes_deployment" "sample" {
  metadata {
    name = "sample-app"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "public.ecr.aws/z9d2n7e1/nginx:1.19.5"
          name  = "nginx"

          port {
            name = "http"
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "sample" {
  metadata {
    name = "sample-service"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-internal" = "true"
    }
  }
  spec {
    port {
      port = 80
      target_port = 80
    }
    type = "LoadBalancer"
    selector = {
      app = "nginx"
    }
  }
}

# Create a local variable for the load balancer name.
locals {
  lb_name = split("-", split(".", kubernetes_service.sample.status.0.load_balancer.0.ingress.0.hostname).0).0
}

# Read information about the load balancer using the AWS provider.
data "aws_lb" "lb" {
  name = local.lb_name
}

resource "aws_vpc_endpoint_service" "sample" {
  acceptance_required        = false
  network_load_balancer_arns = [data.aws_lb.lb.arn]
  allowed_principals = ["arn:aws:iam::${data.aws_caller_identity.consumer.account_id}:root"]

  depends_on = [kubernetes_service.sample]
}
