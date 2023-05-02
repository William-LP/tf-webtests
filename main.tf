locals {
  urls = {
    for k, v in var.urls : k => {
      url                       = v.url
      method                    = coalesce(v.method, var.default_method)
      frequency                 = coalesce(v.frequency, var.default_frequency)
      timeout                   = coalesce(v.timeout, var.default_timeout)
      geo_locations             = coalesce(v.geo_locations, var.default_geo_locations)
      retry_enabled             = coalesce(v.retry_enabled, var.default_retry_enabled)
      description               = coalesce(v.description, var.default_description, "HTTP ${coalesce(v.method, var.default_method)} on ${v.url}. HTTP ${coalesce(v.expected_http_status_code, var.default_expected_http_status_code)} is expected")
      expected_http_status_code = coalesce(v.expected_http_status_code, var.default_expected_http_status_code)
      parse_dependent_requests  = coalesce(v.parse_dependent_requests, var.default_parse_dependent_requests)
      id                        = "${substr(sha1(k), 0, 8)}-${substr(sha1(k), 8, 4)}-${substr(sha1(k), 12, 4)}-${substr(sha1(k), 16, 4)}-${substr(sha1(k), 20, 12)}"
      guid                      = "${substr(strrev(sha1(k)), 0, 8)}-${substr(strrev(sha1(k)), 8, 4)}-${substr(strrev(sha1(k)), 12, 4)}-${substr(strrev(sha1(k)), 16, 4)}-${substr(strrev(sha1(k)), 20, 12)}"
      tags                      = var.tags
      match_content             = v.match_content != null ? v.match_content : null
    }
  }
}

resource "azurerm_application_insights_web_test" "web_test" {
  for_each                = local.urls
  name                    = each.key
  location                = var.application_insights.location
  resource_group_name     = var.application_insights.resource_group_name
  application_insights_id = var.application_insights.id
  kind                    = "ping"
  frequency               = each.value.frequency
  timeout                 = each.value.frequency
  enabled                 = true
  geo_locations           = each.value.geo_locations
  retry_enabled           = each.value.retry_enabled
  description             = each.value.description
  tags                    = var.tags

  configuration = templatefile("${path.module}/webtest.xml.tpl", {
    name                      = each.key
    guid                      = each.value.guid
    id                        = each.value.id
    url                       = replace(each.value.url, "&", "&amp;") # '&' must be translated to html entity encoding. Those following chararacters don't need to be encoded: /-.?=;%+$#@:
    timeout                   = each.value.timeout
    expected_http_status_code = each.value.expected_http_status_code
    method                    = upper(each.value.method)
    parse_dependent_requests  = each.value.parse_dependent_requests
    match_content             = each.value.match_content
  })
}
