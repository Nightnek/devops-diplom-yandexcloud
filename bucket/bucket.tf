resource "yandex_iam_service_account" "sa" {
  name = "sa-for-bucket"
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
}

# Создание бакета с использованием ключа
resource "yandex_storage_bucket" "tstate" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket        = "bucket-stasenko-0226"
  force_destroy = true
}

resource "yandex_storage_bucket_grant" "grant_to_baucket" {
  bucket = yandex_storage_bucket.tstate.id
  grant {
    id          = yandex_iam_service_account.sa.id
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
}

# Создание файла конфигурации для подключения бэкэнда terraform к S3
resource "local_file" "backend" {
  content  = <<EOT
  provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = "b1gpf79u52rvts6oo1mn"
  zone                     = var.zone
  service_account_key_file = file("~/.authorized_key.json")
}
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.5"
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket     = "bucket-stasenko-0226"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = "${yandex_iam_service_account_static_access_key.sa-static-key.access_key}"
    secret_key = "${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
  }
EOT
  filename = "../terraform/providers.tf"

}
