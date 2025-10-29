variable "environment" {
  type        = string
  description = "Environnement de déploiement des ressources"
}

variable "name" {
  type        = string
  description = "Nom du serveur postgresql flexible"
}

variable "resource_group_name" {
  type        = string
  description = "Nom du Resource Group"
}

variable "location" {
  type        = string
  description = "Localisation"
  default     = "westeurope"
}

variable "db_version" {
  type        = string
  description = "Version postgresql"
}

variable "administrator_login" {
  type        = string
  description = "Login admin"
  default     = "postgresqladmin"
}

variable "administrator_password" {
  type        = string
  description = "Mot de passe admin (ou à récupérer dans KeyVault)"
}

variable "zone" {
  type        = string
  description = "Zone (Ex: '3')"
  default     = null
}

variable "sku_name" {
  type        = string
  description = "SKU postgresql (Ex: B_Standard_B1ms)"
  default     = "GP_Standard_D2ds_v5"
}

variable "auto_grow_enabled" {
  type        = bool
  description = "Auto grow storage ?"
  default     = false
}

variable "storage_mb" {
  type        = string
  description = "Taille du storage en mb"
}

variable "storage_tier" {
  type = string
  description = <<DESCRIPTION
  The name of storage performance tier for IOPS of the PostgreSQL Flexible Server. 
  Possible values are P4, P6, P10, P15,P20, P30,P40, P50,P60, P70 or P80. 
  Default value is dependant on the storage_mb value. Please see the storage_tier 
  defaults based on storage_mb table below."
  DESCRIPTION

  default = null

}

variable "user_assigned_identity_id" {
  type        = string
  description = "ID de l'UAI"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Map de tags"
  default     = {}
}

variable "subnet_ids_to_allow" {
  type        = list(string)
  description = <<DESCRIPTION
    Règles firewall si l'accès public est autorisé, pour autoriser les Subnet à accéder au SQL Server, Attention, le service endpoint doit être activé sur le subnet !
  DESCRIPTION
  default     = []
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Autoriser l'accès public ?"
  default     = false
}

variable "private_endpoint_subnet_name" {
  type        = string
  description = "Subnet ou sera déployé le private endpoint"
  default     = null
}

variable "private_endpoint_virtual_network_name" {
  type        = string
  description = "VNET ou sera déployé le private endpoint"
  default     = null
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "Nom du resource group du réseau virtuel (VNET) ou sera créé le private endpoint, obligatoire si le storage account a un private endpoint"
  default     = null
}

variable "key_vault_id" {
  type        = string
  description = "Key vault ou sera stocké le secret de postgresql"
  default     = null
}


variable "identity_type" {
  type        = string
  description = "Type identité à activer sur la ressource ('UserAssigned' et 'SystemAssigned' sont les eules valeurs autorisées)"
  default     = "SystemAssigned"
}

variable "register_postgresqlinfos_to_key_vault" {
  type        = bool
  description = "Définis si les infos du serveur postgresql (mot de passe administrateur, login, url) sont enregistrés dans un key vault ou non"
  default     = false
}

variable "databases" {
  type = map(object({
    name      = string
    charset   = optional(string, "utf8mb4")
    collation = optional(string, "utf8mb4_general_ci")
  }))
  description = "Map de bdd à créer avec le server postgresql"
  default     = {}
}

variable "delegated_subnet_id" {
  type        = string
  description = "The ID of the virtual network subnet to create the postgresql Flexible Server. Changing this forces a new postgresql Flexible Server to be created."
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "The ID of the private DNS zone to create the postgresql Flexible Server. Changing this forces a new postgresql Flexible Server to be created."
  default     = null
}

variable "firewall_rules" {
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  description = <<DESCRIPTION
    Règles firewall si l'accès public est autorisé, pour autoriser les services azure à accéder au postgresql Flexible server (non recommandé),
    AJoutez l'objet suivant :
    "Azure_Services" = {
      start_ip_address = 'O.O.O.O/O'
      end_ip_address   = 'O.O.O.O/O'
    }
  DESCRIPTION
  default     = {}
}
