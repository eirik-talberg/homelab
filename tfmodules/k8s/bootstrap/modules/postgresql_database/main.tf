
#data "hcp_vault_secrets_app" "infra_secrets" {
#  app_name = "${var.environment}-infra-secrets"
#}

resource "random_password" "password" {
  length = 16
}

resource "hcp_vault_secrets_secret" "password" {
  app_name     = data.hcp_vault_secrets_app.infra_secrets.app_name
  secret_name  = "${var.app_name}_psql_password"
  secret_value = random_password.password.result
}

resource "postgresql_role" "this" {
  name     = var.app_name
  login    = true
  password = random_password.password.result
}

resource "postgresql_database" "this" {
  name  = var.app_name
  owner = var.app_name
}
