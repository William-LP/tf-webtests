plugin "azurerm" {
    enabled = true
    version = "0.20.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

rule "azurerm_resource_missing_tags" {
  enabled = true
  tags = ["please_add_tag_block_to_resource"]
  exclude = [] # (Optional) Exclude some resource types from tag checks
}
