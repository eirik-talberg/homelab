provider "kubernetes" {
  config_path = "~/.kube/config-k3s-sbx.yaml"
}

resource "kubernetes_namespace_v1" "demo" {
  metadata {
    name = "demo"
  }
}

resource "kubernetes_manifest" "stackgres_demo_cluster" {
  manifest = yamldecode(file("${path.module}/pg-demo-cluster.yaml"))

  depends_on = [kubernetes_namespace_v1.demo]

}