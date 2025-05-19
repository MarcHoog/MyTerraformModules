
# Checks everything from environment vars to tools
resource "null_resource" "check_requirements" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/setup.sh"
  }
}

resource "random_pet" "name" {
  count     = var.nodes
  length    = 2    # e.g. “fluffy-sheep”
  separator = "-"
}

data "hcloud_image" "snapshot" {
  count = var.nodes
  name = "vm-snapshot-${random_pet.name[count.index].id}"

  lifecycle {
    ignore_errors = true
  }
}

resource "hcloud_server" "server" {
  count       = var.nodes
  name        = random_pet.name[count.index].id            # fixed attribute path :contentReference[oaicite:0]{index=0}
  image       = try(data.hcloud_image.snapshot.id, var.image),
  server_type = var.server_type
  location    = var.location
  ssh_keys    = var.ssh_keys

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

resource "hcloud_volume_attachment" "attachment" {
  count     = var.volume_size != 0 ? var.nodes : 0
  server_id = hcloud_server.server[count.index].id
  volume_id = hcloud_volume.storage[count.index].id
}

resource "null_resource" "snapshot_before_destroy" {
  count = var.nodes
  triggers = {
    server_id = hcloud_server.server[count.index].id
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "hcloud server create-image ${hcloud_server.server[count.index].id} --description 'vm-snapshot-${hcloud_server.server.name}' --type snapshot"
  }

  depends_on = [hcloud_server.server]
}
