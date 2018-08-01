resource "kubernetes_pod" "jenkins" {
  metadata {
    name = "jenkins"
    labels {
      App = "jenkins"
    }
  }

  spec {
    security_context {
      fs_group = 412
    }
    container {
      image = "jenkinsci/blueocean"
      name = "jenkins"
      volume_mount {
        mount_path = "/var/jenkins_home"
        name = "${kubernetes_persistent_volume.jenkins_home.metadata.0.name}"
      }

      volume_mount {
        mount_path = "/var/run/docker.sock"
        name = "dockersock"
      }

      port {
        container_port = 8080
      }
      port {
        container_port = 50000
      }
    }
    volume {
      name = "${kubernetes_persistent_volume.jenkins_home.metadata.0.name}"
    }

    volume {
      name = "dockersock"
      host_path {
        path = "/var/run/docker.sock"
      }
    }
  }
}

resource "kubernetes_persistent_volume" "jenkins_home" {
  "metadata" {
    name = "jenkins-home"
  }

  "spec" {
    access_modes = [
      "ReadWriteMany"
    ]
    "capacity" {
      storage = "10Gi"
    }
    "persistent_volume_source" {
      host_path {
        path = "/jenkins_home"
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
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

output "lb_jenkins_ip" {
  value = "${kubernetes_service.jenkins.load_balancer_ingress.0.ip}"
}
