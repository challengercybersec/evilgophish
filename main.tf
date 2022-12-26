

resource "azurerm_resource_group" "rg" {
  name     = "evilgophish_rsg"
  location = "westeurope"
  tags = {
    "ICO" = "challenger_bot"
  }
}



