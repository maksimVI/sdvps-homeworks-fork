variable "zone" {       # Подставляется дефолтное значение, если не присваивается другое
  default = "ru-central1-a"
  description = "YaCloud network zone"
}

variable "zones" {
  description = "Yandex Cloud default Zone for provisoned resources"
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
}

variable "folder_id" {
  default = "b1g5dp5akgpak24e82ge"
}

variable "service_account_id" {
  default = "aje6dmefv8guk1n2sn1f"
}

variable "cluster_size" {
  default = 2
}

variable "hw-num" {
  default = "-10-04-02"
}