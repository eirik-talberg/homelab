provider "helm" {
  kubernetes {
    config_path = "~/.kube/config-k3s-sbx.yaml"
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config-k3s-sbx.yaml"
}

resource kubernetes_namespace_v1 "postgres-operator" {
  metadata {
    name = "postgres-operator"
  }
}

resource "helm_release" "pg_operator" {
  name      = "postgres-operator"
  namespace = "postgres-operator"

  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator"
  chart      = "postgres-operator"
  version    = "v1.10.1"

  atomic = true

  depends_on = [
    kubernetes_namespace_v1.postgres-operator
  ]
}

resource "helm_release" "pg_operator_ui" {
  name      = "postgres-operator-ui"
  namespace = "postgres-operator"

  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator-ui"
  chart      = "postgres-operator-ui"
  version    = "v1.10.1"

  atomic = true

  depends_on = [
    helm_release.pg_operator
  ]
}