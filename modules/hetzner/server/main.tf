resource "random_pet" "name" {
  count     = var.nodes 
  length    = 2    # e.g. “fluffy-sheep”
  separator = "-"  
}

# Create a Hetzner Cloud server
resource "hcloud_server" "server" {
  count       = var.nodes 
  name        = random_pet[count.index].name.id           
  image       = var.image
  server_type = var.server_type
  location    = var.location
  ssh_keys    = var.ssh_keys
  public_net {
    ipv4_enabled = var.ipv4_enabled 
    ipv6_enabled = var.ipv6_enabled
  }    
}

# Create volume only if volume_name is set
resource "hcloud_volume" "storage" {
  count    = var.volume_size != 0 ? var.nodes : 0
  name     = random_pet.name[count.index].name + "-" + "vl"          
  size     = var.volume_size
  location = var.location
}

# Attach the volume only if it exists
resource "hcloud_volume_attachment" "attachment" {
  count     = var.volume_size != 0 ? var.nodes : 0
  server_id = hcloud_server.server[count.index].id
  volume_id = hcloud_volume.storage[count.index].id
}