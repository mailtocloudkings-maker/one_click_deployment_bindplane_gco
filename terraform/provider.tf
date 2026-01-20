terraform {
  required_version = "~> 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    bindplane = {
      source  = "observiq/bindplane"
      version = "~> 1.7"
    }
    random = {
      source  = "hashicorp/random"
    }
  }
}

provider "google" {
  project = "white-outlook-480705-b1"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "random_id" "suffix" {
  byte_length = 3
}
