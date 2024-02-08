output "public_ip_address" {
  value = [for ip in scaleway_instance_ip.public_ip : ip.address]
}
