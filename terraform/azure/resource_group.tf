resource "azurerm_resource_group" "example" {
  name     = "terragoat-${var.environment}"
  location = var.location
  tags = {
    yor_trace = "32b54325-4f4e-4ff8-a76c-8ff895c33195"
  }
}