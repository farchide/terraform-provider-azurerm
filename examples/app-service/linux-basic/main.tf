provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
}

resource "azurerm_app_service_plan" "main" {
  name                = "${var.prefix}-asp"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "main" {
  name                = "${var.prefix}-appservice"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  site_config {
    dotnet_framework_version = "v4.0"
    remote_debugging_enabled = true
    remote_debugging_version = "VS2019"
  }
  auth_settings {
    active_directory {
      client_id         = "String<The Client ID of this relying party application. Enables OpenIDConnection authentication with Azure Active Directory.>"
      client_secret     = "String<The Client Secret of this relying party application. If no secret is provided, implicit flow will be used.>"
      allowed_audiences = "String<Allowed audience values to consider when validating JWTs issued by Azure Active Directory.>"
    }
  }
}
