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

# Create a firewall
resource "hcloud_firewall" "firewall" {
  name        = var.firewall_name
  description = var.firewall_description

  rule {
    direction     = "in"
    protocol      = var.firewall_in_protocol
    port          = var.firewall_in_port
    source_ips    = var.firewall_in_source_ips
  }

  rule {
    direction       = "out"
    protocol        = "tcp"
    port            = "0-65535"
    destination_ips = ["0.0.0.0/0"]
  }
}

# Attach the server to the firewall
resource "hcloud_firewall_assignment" "assignment" {
  firewall_id = hcloud_firewall.firewall.id
  server_ids  = [hcloud_server.server.id]
}
