output "server_id" {
  description = "The ID of the created Hetzner server"
  value       = hcloud_server.server.id
}

output "volume_id" {
  description = "The ID of the created volume"
  value       = var.volume_name != "" ? hcloud_volume.storage[0].id : null
}