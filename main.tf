locals {
  private_endpoint_name = "PEP-EUR-FR-${var.environment}-${upper(var.name)}"


  subnets_to_authorize_in_postgresql = data.azurerm_subnet.subnets_to_authorize != null ? {
    for key, subnet in data.azurerm_subnet.subnets_to_authorize :
    "${subnet.name}" => {
      start_ip_address = cidrhost(subnet.address_prefix, 0)
      end_ip_address   = cidrhost(subnet.address_prefix, -1)
    }
  } : null


  firewall_rules = merge(
    local.subnets_to_authorize_in_postgresql,
    var.firewall_rules
  )
}

resource "azurerm_postgresql_flexible_server" "postgresql_flexible_server" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.db_version
  administrator_login           = var.administrator_login
  administrator_password        = var.administrator_password
  public_network_access_enabled = var.public_network_access_enabled == false ? "Disabled" : "Enabled"
  delegated_subnet_id           = var.public_network_access_enabled == false ? var.delegated_subnet_id : null
  private_dns_zone_id           = var.public_network_access_enabled == false ? var.private_dns_zone_id : null

  zone                  = var.zone
  backup_retention_days = 7
  sku_name              = var.sku_name

  auto_grow_enabled = var.auto_grow_enabled
  storage_mb        = var.storage_mb
  storage_tier      = var.storage_tier

  dynamic "identity" {
    for_each = var.identity_type == "UserAssigned" ? toset([1]) : toset([])
    content {
      type         = var.identity_type
      identity_ids = [var.user_assigned_identity_id]
    }
  }

  authentication {
    active_directory_auth_enabled = var.active_directory_auth_enabled
    tenant_id                     = var.tenant_id
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


resource "azurerm_postgresql_flexible_server_active_directory_administrator" "postgresql_entraid_administrator" {
  count               = var.active_directory_auth_enabled == true ? 1 : 0
  server_name         = azurerm_postgresql_flexible_server.postgresql_flexible_server.name
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  object_id           = var.postgresql_entraid_administrator_object_id
  principal_name      = var.postgresql_entraid_administrator_name
  principal_type      = var.principal_type
}


resource "azurerm_postgresql_flexible_server_database" "postgresql_flexible_server_databases" {
  for_each   = var.databases
  name       = each.value.name
  server_id  = azurerm_postgresql_flexible_server.postgresql_flexible_server.id
  charset    = each.value.charset
  collation  = each.value.collation
  depends_on = [azurerm_postgresql_flexible_server.postgresql_flexible_server]
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "firewall_rule" {
  for_each         = local.firewall_rules != {} && var.public_network_access_enabled == true ? local.firewall_rules : {}
  name             = each.key
  server_id        = azurerm_postgresql_flexible_server.postgresql_flexible_server.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

module "postgresql_private_endpoint" {
  count                               = var.public_network_access_enabled == false || (local.subnets_to_authorize_in_postgresql != {} && var.public_network_access_enabled == true) ? 1 : 0
  source                              = "../azure_private_endpoint"
  private_endpoint_name               = local.private_endpoint_name
  subnet_name                         = var.private_endpoint_subnet_name
  virtual_network_name                = var.private_endpoint_virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  resource_group_name                 = var.resource_group_name
  private_connection_resource_id      = azurerm_postgresql_flexible_server.postgresql_flexible_server.id
  subresourceType                     = "postgresqlServer"
}

resource "azurerm_key_vault_secret" "postgresql_admin_password" {
  count        = var.register_postgresqlinfos_to_key_vault == true ? 1 : 0
  name         = "PostgreSQL-Admin-Password"
  value        = var.administrator_password
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "postgresql_admin_login" {
  count        = var.register_postgresqlinfos_to_key_vault == true ? 1 : 0
  name         = "PostgreSQL-Admin-login"
  value        = var.administrator_login
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "postgresql_fqdn" {
  count        = var.register_postgresqlinfos_to_key_vault == true ? 1 : 0
  name         = "PostgreSQL-fqdn"
  value        = azurerm_postgresql_flexible_server.postgresql_flexible_server.fqdn
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "postgresql_database" {
  for_each     = var.databases != {} && var.register_postgresqlinfos_to_key_vault == true ? var.databases : {}
  name         = replace("postgresql-database-${each.value.name}", "_", "-")
  value        = each.value.name
  key_vault_id = var.key_vault_id
}