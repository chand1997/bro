variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project     = "expense"
    Environment = "dev"
    Terraform   = "true"
  }
}


variable "zone_id" {
  default = "Z02189981TMASRQY8AQ08"
}

variable "domain_name" {
  default = "chandev.site"
}
