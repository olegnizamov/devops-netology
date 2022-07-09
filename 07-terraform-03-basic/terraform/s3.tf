terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "olegnizamov"
    region     = "ru-central1-a"
    key        = "s3/terraform.tfstate"
    access_key = ""
    secret_key = ""

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}