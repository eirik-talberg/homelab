
data "hcp_vault_secrets_app" "infra_secrets" {
  app_name = "${var.environment}-infra-secrets"
}

data "hcp_vault_secrets_secret" "postgresql_username" {
  app_name    = "${var.environment}-infra-secrets"
  secret_name = "postgresql_user"
}

data "hcp_vault_secrets_secret" "postgresql_password" {
  app_name    = "${var.environment}-infra-secrets"
  secret_name = "postgresql_password"
}

provider "postgresql" {
  host            = "${var.environment}-psql-01.taldev.no"
  port            = var.port
  database        = var.database
  username        = data.hcp_vault_secrets_secret.postgresql_username.secret_value
  password        = data.hcp_vault_secrets_secret.postgresql_password.secret_value
  sslmode         = var.ssl_mode
  connect_timeout = 15
}

provider "hcp" {
  project_id = var.hcp_project_id
}
