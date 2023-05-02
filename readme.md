# web-test
This module allows you to setup [Azure Web Tests](https://learn.microsoft.com/en-us/azure/azure-monitor/app/availability-alerts).

## Example usage

This module needs at least an `application_insights` and a urls object as an input :

```bash
locals {
    urls = {
        # This test will used all default values
        "example-using-default" = {
            url                       = "https://my-api.fr/simple/example"
        },        
        # This test will override all default value with custom one
        "exhaustif-example" = {
            url                       = "https://my-api.fr/exhaustif/example"
            method                    = "GET"
            frequency                 = 300
            timeout                   = 30
            geo_locations             = ["us-va-ash-azr", "emea-fr-pra-edge"]
            expected_http_status_code = 200
            retry_enabled             = true
            description               = "Getting some resource on my api"
            parse_dependent_requests  = true
            match_content             = "OK"
        }
    }
}

module "web_test" {
  source               = "git::https://poweruptech@dev.azure.com/poweruptech/mainplatform/_git/tf-modules//web-ping?ref=<TAG_VERSION>"
  application_insights = data.azurerm_application_insights.example
  urls                 = local.urls
  default_frequency    = 900 # 15 minutes
  default_description               = "My app test"
  default_expected_http_status_code = 200
  default_geo_locations = [
    "us-va-ash-azr",     # East US
    "us-ca-sjc-azr",     # West US
    "apac-sg-sin-azr",   # Southeast Asia
    "latam-br-gru-edge", # Brazil South
    "emea-fr-pra-edge"   # France Central
  ]
  default_method                   = "GET"
  default_parse_dependent_requests = true
  default_retry_enabled            = true
  default_timeout                  = 30  
  tags = { "environement = "prod" }
}
```

### Tags

When a WebTest is created, Azure will automatically appends a `hidden-link` tag to the resource.
You should also add this tag to your code or terraform will conflict agains Azure to remove/apply that tag at every run :
```bash
tags = merge(local.tags, { "hidden-link:/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_application_insights.example.resource_group_name}/providers/Microsoft.Insights/components/${azurerm_application_insights.example.name}" = "Resource" })
```
As of yet this is not something that can be taken care of at module level (see [this issue](https://github.com/hashicorp/terraform/issues/22544)).


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.6 |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights_web_test.web_test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_web_test) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_insights"></a> [application\_insights](#input\_application\_insights) | (Required) The Application Insights component on which the WebTests operate. | `any` | n/a | yes |
| <a name="input_default_description"></a> [default\_description](#input\_default\_description) | (Optional) Default purpose/user defined descriptive test for those WebTests. Default is empty | `string` | `"HTTP <METHOD> on <URL>. HTTP <EXPECTED_HTTP_STATUS_CODE> is expected"` | no |
| <a name="input_default_expected_http_status_code"></a> [default\_expected\_http\_status\_code](#input\_default\_expected\_http\_status\_code) | (Optional) Default expected HTTP status code those WebTests should return. Default is 200 | `number` | `200` | no |
| <a name="input_default_frequency"></a> [default\_frequency](#input\_default\_frequency) | (Optional) Default interval in seconds between test runs for those WebTests. Valid options are 300, 600 and 900. Defaults to 300 | `number` | `300` | no |
| <a name="input_default_geo_locations"></a> [default\_geo\_locations](#input\_default\_geo\_locations) | (Optional) A default list of where to physically run the tests from to give global coverage for accessibility of your application. Default to East US, West US, Southeast Asia, Brazil South and France Central | `list(string)` | <pre>[<br>  "us-va-ash-azr",<br>  "us-ca-sjc-azr",<br>  "apac-sg-sin-azr",<br>  "latam-br-gru-edge",<br>  "emea-fr-pra-edge"<br>]</pre> | no |
| <a name="input_default_method"></a> [default\_method](#input\_default\_method) | (Optional) Default HTTP method those WebTests will use. | `string` | `"GET"` | no |
| <a name="input_default_parse_dependent_requests"></a> [default\_parse\_dependent\_requests](#input\_default\_parse\_dependent\_requests) | (Optional) The test requests images, scripts, style files, and other files that are part of the webpage under test. Default is true | `bool` | `true` | no |
| <a name="input_default_retry_enabled"></a> [default\_retry\_enabled](#input\_default\_retry\_enabled) | (Optional) Allow for retries should those WebTests fail. Default is true | `bool` | `true` | no |
| <a name="input_default_timeout"></a> [default\_timeout](#input\_default\_timeout) | (Optional) Default interval in seconds until those WebTests will timeout and fail. Valid options are 30, 60, 90 and 120. Default is 30 | `number` | `30` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(any)` | `{}` | no |
| <a name="input_urls"></a> [urls](#input\_urls) | (Required) Map of object that must at least contain an url parameter. Every default configuration can be overridden here | <pre>map(object({<br>    url                       = string<br>    method                    = optional(string)<br>    frequency                 = optional(number)<br>    timeout                   = optional(number)<br>    geo_locations             = optional(list(string))<br>    expected_http_status_code = optional(number)<br>    retry_enabled             = optional(bool)<br>    description               = optional(string)<br>    parse_dependent_requests  = optional(bool)<br>    match_content             = optional(string)<br>    }<br>  ))</pre> | n/a | yes |

## Outputs

No outputs.

## Geo location

You can use the following population tags for the geo-location attribute when you deploy an availability URL ping test :

|  Display name | Population name |
| --- | --- |
| Australia East | emea-au-syd-edge |
| Brazil South | latam-br-gru-edge |
| Central US | us-fl-mia-edge |
| East Asia | apac-hk-hkn-azr |
| East US | us-va-ash-azr |
| France South (Formerly France Central) | emea-ch-zrh-edge |
| France Central | emea-fr-pra-edge |
| Japan East | apac-jp-kaw-edge |
| North Europe | emea-gb-db3-azr |
| North Central US | us-il-ch1-azr |
| South Central US | us-tx-sn1-azr |
| Southeast Asia | apac-sg-sin-azr |
| UK West | emea-se-sto-edge |
| West Europe | emea-nl-ams-azr |
| West US | us-ca-sjc-azr |
| UK South | emea-ru-msa-edge |

Source : <https://learn.microsoft.com/en-us/azure/azure-monitor/app/availability-standard-tests#azure>
