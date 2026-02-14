variable "cloud_id" {
  type        = string
  default = "b1gua5vm4htrvegtvhce"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}
variable "folder_id" {
  type        = string
  default = "b1gpf79u52rvts6oo1mn"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

# variable "service_account_key_file" {
#   description = "Путь к файлу ключа сервисного аккаунта"
#   type        = string
# }
variable "ssh_public_key" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}
variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "ssh_public_key_path" {
  description = "Путь к публичному SSH ключу"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "vpc_name" {
  description = "Имя виртуальной сети k8s"
  type        = string
  default     = "k8s-network"
}

variable "subnet_zone" {
  type        = list(string)
  description = "Список зон"
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

variable "cidr" {
  type        = list(string)
  description = "Список CIDR-ов"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}


variable "master" {
  type        = map(any)
  description = "Описание ресурсов для master нод"

}

variable "worker" {
  type        = map(any)
  description = "Описание ресурсов для worker нод"
}

variable "bastion" {
  type        = map(any)
  description = "Описание ресурсов для master нод"

}

variable "listener_grafana" {
  type        = map(any)
  description = "Описание параметров listener для grafana"
}
variable "listener_web_app" {
  type        = map(any)
  description = "Описание параметров listener для web-приложения"
}
