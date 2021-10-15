terraform {
  required_version = ">= 0.13"
  required_providers {
    huaweicloud = {
      source  = "local-registry/huaweicloud/huaweicloud"
      version = "~> 1.28.0"
    }
  }
}

# Configure the HuaweiCloud Provider
provider "huaweicloud" {
  region      = var.region
  access_key  = var.ak
  secret_key  = var.sk
}
