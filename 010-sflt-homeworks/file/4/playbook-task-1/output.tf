// цикл for создаёт список IP-адресов для всех экземпляров

output "internal_ip_addresses" {
  value = [for i in range(length(yandex_compute_instance.vms)) : yandex_compute_instance.vms[i].network_interface.0.ip_address]
}

output "external_ip_addresses" {
  value = [for i in range(length(yandex_compute_instance.vms)) : yandex_compute_instance.vms[i].network_interface.0.nat_ip_address]
}

//

output "subnet" {
  value = yandex_vpc_subnet.subnet.id
}