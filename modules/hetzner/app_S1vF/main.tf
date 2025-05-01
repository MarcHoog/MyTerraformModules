# Create a Hetzner Cloud server
resource "hcloud_server" "server" {
  name        = var.server_name
  image       = var.image
  server_type = var.server_type
  location    = var.location
  ssh_keys    = var.ssh_keys
}

# Create a block storage volume (as a stand-in for object storage)
resource "hcloud_volume" "storage" {
  name     = var.volume_name
  size     = var.volume_size  # in GB
  location = var.location
}

# Attach the volume to the server
resource "hcloud_volume_attachment" "attachment" {
  server_id = hcloud_server.server.id
  volume_id = hcloud_volume.storage.id
}
