resource "azurerm_private_dns_zone" "foggykitchen_acr_dns_zone" {
  count               = var.enable_acr_private_endpoint && var.enable_private_dns ? 1 : 0
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "foggykitchen_acr_dns_zone_link" {
  count                 = var.enable_acr_private_endpoint && var.enable_private_dns ? 1 : 0
  name                  = "acr-dns-link"
  resource_group_name   = azurerm_resource_group.foggykitchen_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.foggykitchen_acr_dns_zone[0].name
  virtual_network_id    = module.vnet.vnet_id

  tags = var.tags
}