resource "random_pet" "name" {
  length    = 2    # e.g. “fluffy-sheep”
  separator = "-"  
}

# Create a Hetzner Cloud server
resource "hcloud_server" "server" {
  name        = var.server_name != "" ? var.server_name : random_pet.name.id           
  image       = var.image
  server_type = var.server_type
  location    = var.location
  ssh_keys    = var.ssh_keys
}

# Create volume only if volume_name is set
resource "hcloud_volume" "storage" {
  count    = var.volume_name != "" ? 1 : 0
  name     = var.volume_name
  size     = var.volume_size
  location = var.location
}

# Attach the volume only if it exists
resource "hcloud_volume_attachment" "attachment" {
  count     = var.volume_name != "" ? 1 : 0
  server_id = hcloud_server.server.id
  volume_id = hcloud_volume.storage[0].id
}