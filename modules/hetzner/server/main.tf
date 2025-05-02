# Generate a unique pet name per node
resource "random_pet" "name" {
  count     = var.nodes
  length    = 2    # e.g. “fluffy-sheep”
  separator = "-"
}

# Create a Hetzner Cloud server per node
resource "hcloud_server" "server" {
  count       = var.nodes
  name        = random_pet.name[count.index].id            # fixed attribute path :contentReference[oaicite:0]{index=0}
  image       = var.image
  server_type = var.server_type
  location    = var.location
  user_data   = data.cloudinit_config.config.rendered       
  ssh_keys    = local.ssh_keys

  public_net {
    ipv4_enabled = var.ipv4_enabled
    ipv6_enabled = var.ipv6_enabled
  }
}

# Create a volume per node only if volume_size > 0
resource "hcloud_volume" "storage" {
  count    = var.volume_size != 0 ? var.nodes : 0
  name     = "${random_pet.name[count.index].id}-vl"       # use interpolation :contentReference[oaicite:1]{index=1}
  size     = var.volume_size
  location = var.location
}

# Attach the volume to its server
resource "hcloud_volume_attachment" "attachment" {
  count     = var.volume_size != 0 ? var.nodes : 0
  server_id = hcloud_server.server[count.index].id         # server ID is correct here :contentReference[oaicite:2]{index=2}
  volume_id = hcloud_volume.storage[count.index].id
}

resource "hcloud_ssh_key" "ssh_key" {
  count = var.ssh_key_path != "" ? 1 : 0
  name  = "terraform-ssh-key-${random_pet.name[count.index].id}"          
  public_key = file(var.ssh_key_path)           
}

data "cloudinit_config" "config" {
  gzip = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/template/cloud-init.yaml.tftpl", {
      has_operator_user = true
      operator_user = "bubble"
      ssh_keys      = local.ssh_keys
      })
    }
}