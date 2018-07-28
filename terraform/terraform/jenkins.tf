resource "kubernetes_pod" "jenkins" {
  metadata {
    name = "jenkins"
    labels {
      App = "jenkins"
    }
  }

  spec {
    container {
      image = "jenkins/jenkins:lts"
      name  = "jenkins"

      port {
        container_port = 8080
      }
      port {
        container_port = 50000
      }
    }
  }
}

resource "kubernetes_service" "jenkins" {
  metadata {
    name = "jenkins"
  }
  spec {
    selector {
      App = "${kubernetes_pod.jenkins.metadata.0.labels.App}"
    }
    port {
      name = "ui"
      port = 8080
      node_port = 31102
    }
    port {
      name = "protocol"
      port = 50000
      node_port = 31103
    }

    type = "NodePort"
  }
}
