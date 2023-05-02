variable "application_insights" {
  type        = any
  description = "(Required) The Application Insights component on which the WebTests operate."
}

variable "urls" {
  type = map(object({
    url                       = string
    method                    = optional(string)
    frequency                 = optional(number)
    timeout                   = optional(number)
    geo_locations             = optional(list(string))
    expected_http_status_code = optional(number)
    retry_enabled             = optional(bool)
    description               = optional(string)
    parse_dependent_requests  = optional(bool)
    match_content             = optional(string)
    }
  ))
  description = "(Required) Map of object that must at least contain an url parameter. Every default configuration can be overridden here"
}

variable "default_geo_locations" {
  type = list(string)
  default = [
    "us-va-ash-azr",     # East US
    "us-ca-sjc-azr",     # West US
    "apac-sg-sin-azr",   # Southeast Asia
    "latam-br-gru-edge", # Brazil South
    "emea-fr-pra-edge"   # France Central
  ]
  description = "(Optional) A default list of where to physically run the tests from to give global coverage for accessibility of your application. Default to East US, West US, Southeast Asia, Brazil South and France Central"
}

variable "default_method" {
  type        = string
  default     = "GET"
  description = "(Optional) Default HTTP method those WebTests will use."
}

variable "default_frequency" {
  type        = number
  default     = 300 # 5 minutes
  description = "(Optional) Default interval in seconds between test runs for those WebTests. Valid options are 300, 600 and 900. Defaults to 300"
}

variable "default_timeout" {
  type        = number
  default     = 30
  description = "(Optional) Default interval in seconds until those WebTests will timeout and fail. Valid options are 30, 60, 90 and 120. Default is 30"

  validation {
    condition     = contains([30, 60, 90, 120], var.default_timeout)
    error_message = "Expected timeout to be one of [30, 60, 90, 120]"
  }
}

variable "default_expected_http_status_code" {
  type        = number
  default     = 200
  description = "(Optional) Default expected HTTP status code those WebTests should return. Default is 200"
}

variable "default_retry_enabled" {
  type        = bool
  default     = true # If the test fails, we’ll try it again after 20 seconds. We’ll record a failure only if it fails three times in a row.
  description = "(Optional) Allow for retries should those WebTests fail. Default is true"
}

variable "default_description" {
  type        = string
  default     = ""
  description = "(Optional) Default purpose/user defined descriptive test for those WebTests. Default is empty"
}

variable "default_parse_dependent_requests" {
  type        = bool
  default     = true
  description = "(Optional) The test requests images, scripts, style files, and other files that are part of the webpage under test. Default is true"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "(Optional) A mapping of tags to assign to the resource."
}
