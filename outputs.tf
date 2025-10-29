output "postgresql_flexible_server_id" {
  description = "ID du serveur postgresql flexible"
  value       = azurerm_mysql_flexible_server.mysql_flexible_server.id
}
