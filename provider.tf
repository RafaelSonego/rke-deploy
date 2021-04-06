terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "1.2.1"
    }
  }
  required_version = ">= 0.13"
}

provider "rke" {
  log_file = "rke_debug.log"
}