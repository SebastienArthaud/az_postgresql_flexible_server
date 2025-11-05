data "azurerm_subnet" "subnets_to_authorize" {
  for_each             = var.subnet_ids_to_allow != [] ? toset(var.subnet_ids_to_allow) : null
  name                 = reverse(split("/", each.key))[0]
  virtual_network_name = split("/", each.key)[8]
  resource_group_name  = split("/", each.key)[4]
}