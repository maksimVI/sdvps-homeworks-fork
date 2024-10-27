terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  // token     =    Terraform считывает значение ENV переменной YC_TOKEN.
  cloud_id  = "b1g1n6hn9bll201cokk5"
  folder_id = "b1g5dp5akgpak24e82ge"
  zone = var.zone // "ru-centra11-a" - дефолтное значение установлено в variable.tf
}

/*

Где:

source — глобальный адрес источника провайдера.
required_version — минимальная версия Terraform, с которой совместим провайдер.
provider — название провайдера.
zone — зона доступности, в которой по умолчанию будут создаваться все облачные ресурсы.

*/