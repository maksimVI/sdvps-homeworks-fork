resource "yandex_compute_image" "ubuntu_2004" {
  source_family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance_group" "ig" {
  name                = "fixed-ig-with-balancer"
  service_account_id  = var.service_account_id
  deletion_protection = false

  instance_template {
    platform_id = "standard-v2" // standard-v2 — для архивных хостов на платформе Intel Cascade; standard-v3 — Lake Intel® Ice Lake
    resources {
      cores  = 2
      memory = 2
      core_fraction = 5         // Гарантированная доля vCPU — 5%
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = yandex_compute_image.ubuntu_2004.id
        type     = "network-hdd"
        size     = "10"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.network.id
      subnet_ids = [yandex_vpc_subnet.subnet.id]
      nat        = true
    }

    metadata = {
      user-data = "${file("./meta.txt")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = var.cluster_size
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "Целевая группа Network Load Balancer"
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
    target_group_id = yandex_compute_instance_group.ig.load_balancer[0].target_group_id

    healthcheck {
      name = "http${var.hw-num}"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}