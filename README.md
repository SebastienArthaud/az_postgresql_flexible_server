<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.11 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_postgresql_private_endpoint"></a> [postgresql\_private\_endpoint](#module\_postgresql\_private\_endpoint) | ../azure_private_endpoint | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.postgresql_admin_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.postgresql_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.postgresql_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.postgresql_fqdn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_postgresql_flexible_server.postgresql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_active_directory_administrator.postgresql_entraid_administrator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_active_directory_administrator) | resource |
| [azurerm_postgresql_flexible_server_database.postgresql_flexible_server_databases](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) | resource |
| [azurerm_postgresql_flexible_server_firewall_rule.firewall_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_firewall_rule) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subnet.subnets_to_authorize](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password) | Mot de passe admin (ou à récupérer dans KeyVault) | `string` | n/a | yes |
| <a name="input_db_version"></a> [db\_version](#input\_db\_version) | Version postgresql | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environnement de déploiement des ressources | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Nom du serveur postgresql flexible | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Nom du Resource Group | `string` | n/a | yes |
| <a name="input_storage_mb"></a> [storage\_mb](#input\_storage\_mb) | Taille du storage en mb | `string` | n/a | yes |
| <a name="input_active_directory_auth_enabled"></a> [active\_directory\_auth\_enabled](#input\_active\_directory\_auth\_enabled) | active\_directory\_auth\_enabled | `bool` | `false` | no |
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | Login admin | `string` | `"postgresqladmin"` | no |
| <a name="input_auto_grow_enabled"></a> [auto\_grow\_enabled](#input\_auto\_grow\_enabled) | Auto grow storage ? | `bool` | `false` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | Map de bdd à créer avec le server postgresql | <pre>map(object({<br/>    name      = string<br/>    charset   = optional(string, "utf8mb4")<br/>    collation = optional(string, "utf8mb4_general_ci")<br/>  }))</pre> | `{}` | no |
| <a name="input_delegated_subnet_id"></a> [delegated\_subnet\_id](#input\_delegated\_subnet\_id) | The ID of the virtual network subnet to create the postgresql Flexible Server. Changing this forces a new postgresql Flexible Server to be created. | `string` | `null` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | Règles firewall si l'accès public est autorisé, pour autoriser les services azure à accéder au postgresql Flexible server (non recommandé),<br/>    AJoutez l'objet suivant :<br/>    "Azure\_Services" = {<br/>      start\_ip\_address = 'O.O.O.O/O'<br/>      end\_ip\_address   = 'O.O.O.O/O'<br/>    } | <pre>map(object({<br/>    start_ip_address = string<br/>    end_ip_address   = string<br/>  }))</pre> | `{}` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Type identité à activer sur la ressource ('UserAssigned' et 'SystemAssigned' sont les eules valeurs autorisées) | `string` | `"SystemAssigned"` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Key vault ou sera stocké le secret de postgresql | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Localisation | `string` | `"westeurope"` | no |
| <a name="input_postgresql_entraid_administrator_name"></a> [postgresql\_entraid\_administrator\_name](#input\_postgresql\_entraid\_administrator\_name) | The name of Azure Active Directory principal.<br/>  Changing this forces a new resource to be created<br/>  If it is a user, the User Principal Name must be specified here. | `string` | `null` | no |
| <a name="input_postgresql_entraid_administrator_object_id"></a> [postgresql\_entraid\_administrator\_object\_id](#input\_postgresql\_entraid\_administrator\_object\_id) | The object ID of a user, service principal or security group <br/>  in the Azure Active Directory tenant set as the Flexible Server Admin.<br/>  Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_principal_type"></a> [principal\_type](#input\_principal\_type) | The type of Azure Active Directory principal.<br/>  Possible values are Group, ServicePrincipal and User.<br/>  Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | The ID of the private DNS zone to create the postgresql Flexible Server. Changing this forces a new postgresql Flexible Server to be created. | `string` | `null` | no |
| <a name="input_private_endpoint_subnet_name"></a> [private\_endpoint\_subnet\_name](#input\_private\_endpoint\_subnet\_name) | Subnet ou sera déployé le private endpoint | `string` | `null` | no |
| <a name="input_private_endpoint_virtual_network_name"></a> [private\_endpoint\_virtual\_network\_name](#input\_private\_endpoint\_virtual\_network\_name) | VNET ou sera déployé le private endpoint | `string` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Autoriser l'accès public ? | `bool` | `false` | no |
| <a name="input_register_postgresqlinfos_to_key_vault"></a> [register\_postgresqlinfos\_to\_key\_vault](#input\_register\_postgresqlinfos\_to\_key\_vault) | Définis si les infos du serveur postgresql (mot de passe administrateur, login, url) sont enregistrés dans un key vault ou non | `bool` | `false` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU postgresql (Ex: B\_Standard\_B1ms) | `string` | `"GP_Standard_D2ds_v5"` | no |
| <a name="input_storage_tier"></a> [storage\_tier](#input\_storage\_tier) | The name of storage performance tier for IOPS of the PostgreSQL Flexible Server. <br/>  Possible values are P4, P6, P10, P15,P20, P30,P40, P50,P60, P70 or P80. <br/>  Default value is dependant on the storage\_mb value. Please see the storage\_tier <br/>  defaults based on storage\_mb table below." | `string` | `null` | no |
| <a name="input_subnet_ids_to_allow"></a> [subnet\_ids\_to\_allow](#input\_subnet\_ids\_to\_allow) | Règles firewall si l'accès public est autorisé, pour autoriser les Subnet à accéder au SQL Server, Attention, le service endpoint doit être activé sur le subnet ! | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map de tags | `map(string)` | `{}` | no |
| <a name="input_user_assigned_identity_id"></a> [user\_assigned\_identity\_id](#input\_user\_assigned\_identity\_id) | ID de l'UAI | `string` | `null` | no |
| <a name="input_virtual_network_resource_group_name"></a> [virtual\_network\_resource\_group\_name](#input\_virtual\_network\_resource\_group\_name) | Nom du resource group du réseau virtuel (VNET) ou sera créé le private endpoint, obligatoire si le storage account a un private endpoint | `string` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone (Ex: '3') | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_postgresql_flexible_server_id"></a> [postgresql\_flexible\_server\_id](#output\_postgresql\_flexible\_server\_id) | ID du serveur postgresql flexible |
<!-- END_TF_DOCS -->

## `storage_tier` defaults based on `storage_mb`

| `storage_mb` | GiB   | TiB | Default | Supported `storage_tier`'s           | Provisioned `IOPS`  |
|:------------:|:-----:|:---:|:-------:|:------------------------------------:|:-------------------:|
| 32768        | 32    |  -  | P4      | P4, P6, P10, P15, P20, P30, P40, P50 | 120                 |
| 65536        | 64    |  -  | P6      | P6, P10, P15, P20, P30, P40, P50     | 240                 |
| 131072       | 128   |  -  | P10     | P10, P15, P20, P30, P40, P50         | 500                 |
| 262144       | 256   |  -  | P15     | P15, P20, P30, P40, P50              | 1,100               |
| 524288       | 512   |  -  | P20     | P20, P30, P40, P50                   | 2,300               |
| 1048576      | 1024  |  1  | P30     | P30, P40, P50                        | 5,000               |
| 2097152      | 2048  |  2  | P40     | P40, P50                             | 7,500               |
| 4193280      | 4095  |  4  | P50     | P50                                  | 7,500               |
| 4194304      | 4096  |  4  | P50     | P50                                  | 7,500               |
| 8388608      | 8192  |  8  | P60     | P60, P70                             | 16,000              |
| 16777216     | 16384 |  16 | P70     | P70, P80                             | 18,000              |
| 33553408     | 32767 |  32 | P80     | P80                                  | 20,000              |

-> **Note:** Host Caching (ReadOnly and Read/Write) is supported on disk sizes less than 4194304 MiB. This means any disk that is provisioned up to 4193280 MiB can take advantage of Host Caching. Host caching is not supported for disk sizes larger than 4193280 MiB. For example, a P50 premium disk provisioned at 4193280 GiB can take advantage of Host caching while a P50 disk provisioned at 4194304 MiB cannot. Moving from a smaller disk size to a larger disk size, greater than 4193280 MiB, will cause the disk to lose the disk caching ability.
