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
  default = "Z06683192BNOEZATLAT6O"
}

variable "domain_name" {
  default = "chandev.site"
}
