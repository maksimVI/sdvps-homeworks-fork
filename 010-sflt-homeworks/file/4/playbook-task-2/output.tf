output "external_ip_addresses" {
  description = "Список внешних IP-адресов для каждого экземпляра"
  value       = yandex_compute_instance_group.ig.instances[*].network_interface[0].nat_ip_address
}

output "internal_ip_addresses" {
  description = "Список внутренних IP-адресов для каждого экземпляра"
  value       = yandex_compute_instance_group.ig.instances[*].network_interface[0].ip_address
}

output "hostnames" {
  description = "Список имен хостов для каждого экземпляра"
  value       = yandex_compute_instance_group.ig.instances[*].fqdn
}
