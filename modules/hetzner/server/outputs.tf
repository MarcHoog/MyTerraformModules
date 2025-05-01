output "server_id" {
  description = "The ID of the created Hetzner server"
  value       = hcloud_server.server.id
}

output "volume_id" {
  description = "The ID of the created volume"
  value       = hcloud_volume.storage.id
}