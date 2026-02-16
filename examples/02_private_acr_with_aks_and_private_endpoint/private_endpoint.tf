
module "private_endpoint_acr" {
  source = "../../"
  count  = var.enable_acr_private_endpoint ? 1 : 0

  name                = "fk-acr-pe"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
  subnet_id           = module.vnet.subnet_ids["fk-subnet-private-endpoints"]

  private_connection_resource_id = azurerm_container_registry.foggykitchen_acr.id
  subresource_names              = ["registry"]
  is_manual_connection           = false

  private_dns_zone_group_name = "acr-dns-zone-group"
  private_dns_zone_ids        = var.enable_private_dns ? [azurerm_private_dns_zone.foggykitchen_acr_dns_zone[0].id] : []

  tags = var.tags

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.foggykitchen_acr_dns_zone_link
  ]
}
