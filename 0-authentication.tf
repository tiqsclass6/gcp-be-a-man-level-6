# https://registry.terraform.io/providers/hashicorp/google/latest/docs

provider "google" {
  project     = "class-6-5-tiqs"                   # Your Project ID
  region      = "us-central1"                      # Your Region
  credentials = "class-6-5-tiqs-095c33bf9f57.json" # Your JSON Key
}
