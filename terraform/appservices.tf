resource "azurerm_service_plan" "exampleAppserviceplan" {
  name                = "tempresourcenameserviceplan" # secret
  location            = "northeurope"
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "exampleWebapp" {
  name                = "tempresourcenamewebapp" # secret
  location            = "northeurope"
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name
  service_plan_id = azurerm_service_plan.exampleAppserviceplan.id
  public_network_access_enabled = true

  https_only = true

  site_config {
    ip_restriction_default_action = "Allow"
    always_on = "false"

    app_command_line = "npx http-server -p 8080"

    application_stack {
      node_version = "20-lts"
    }
  }

  logs{
    application_logs {
      file_system_level = "Verbose"
    }
  }
}

resource "azurerm_linux_web_app" "exampleApiapp" {
  name                = "tempresourcenameapiapp" # secret
  location            = "northeurope"
  resource_group_name = data.azurerm_resource_group.exampleResourcegroup.name
  service_plan_id = azurerm_service_plan.exampleAppserviceplan.id
  public_network_access_enabled = true

  https_only = true

  site_config {
    ip_restriction_default_action = "Allow"
    always_on = "false"

    app_command_line = "npm start"

    application_stack {
      node_version = "20-lts"
    }
  }

  logs{
    application_logs {
      file_system_level = "Verbose"
    }
  }

  app_settings = {
    "DATABASE_URL" = "tempdatabaseurl"
    "ENVIRONMENT" = "PRODUCTION"
  }
}