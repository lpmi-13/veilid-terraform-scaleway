output "public_ipv4_address" {
  value = [for ip in scaleway_instance_ip.public_ipv4 : ip.address]
}

output "public_ipv6_address" {
  value = [for ip in scaleway_instance_ip.public_ipv6 : ip.address]
}
