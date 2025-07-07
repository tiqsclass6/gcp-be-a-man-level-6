# https://www.terraform.io/language/settings/backends/gcs

terraform {
  backend "gcs" {
    bucket      = "be-a-man-level-6" # Insert your bucket name here
    prefix      = "terraform/state"
    credentials = "class-6-5-tiqs-095c33bf9f57.json" # Insert your JSON key here
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}
