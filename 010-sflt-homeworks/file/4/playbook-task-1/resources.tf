resource "yandex_compute_image" "ubuntu_2004" {
  source_family = "ubuntu-2004-lts"
}

resource "yandex_compute_disk" "boot-disk" {
  count    = 2
  name     = "boot-disk-${count.index + 1}${var.hw-num}"
  type     = "network-hdd"
  zone     = var.zone // "ru-central1-a"
  size     = "10"
  image_id = yandex_compute_image.ubuntu_2004.id
}

resource "yandex_compute_instance" "vms" {
  count = 2
  name = "vm-${count.index}${var.hw-num}"
  hostname = "vm-${count.index}${var.hw-num}"
  platform_id = "standard-v2" // standard-v2 — для архивных хостов на платформе Intel Cascade; standard-v3 — Lake Intel® Ice Lake
  zone = var.zone

  resources {
    cores  = 2
    memory = 2
    core_fraction = 5         // Гарантированная доля vCPU — 5%
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk[count.index].id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
  }
  
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_vpc_network" "network" {
  name = "network${var.hw-num}"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet${var.hw-num}"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_lb_target_group" "target-group" {
  name      = "target-group${var.hw-num}"

  target {
    subnet_id = yandex_vpc_subnet.subnet.id
    address   = yandex_compute_instance.vms[0].network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet.id
    address   = yandex_compute_instance.vms[1].network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "load_balancer" {
  name = "load-balancer${var.hw-num}"

  listener {
    name = "listener${var.hw-num}"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.target-group.id

    healthcheck {
      name = "http${var.hw-num}"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}