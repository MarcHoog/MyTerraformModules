# Hehe if this works it's kinda genius not gonna lie
resource "random_pet" "name" {
  count     = var.nodes
  length    = 2    # e.g. “fluffy-sheep”
  separator = "-"

  keepers = {
    # change this value only when you really want new names
    module_version = "v1.0.0"
  }
}

# TODO This still doesn't go very lekker tbh
resource "null_resource" "get_snapshots" {
  triggers = {
    node_names = join(",", random_pet.name[*].id)
  }

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p "${path.module}/tmp"
      python3 "${path.module}/scripts/get_snapshots.py" \
        --names "${join(" ", random_pet.name[*].id)}" \
        --output "${path.module}/tmp/snapshots.json"
    EOT
  }

  depends_on = [random_pet.name]
}



data "local_file" "snapshot_ids" {
  depends_on = [null_resource.get_snapshots]
  filename   = "${path.module}/tmp/snapshots.json"
}

resource "hcloud_server" "server" {
  count       = var.nodes
  name        = random_pet.name[count.index].id
  image       = local.snapshot_ids[count.index] != "" ? local.snapshot_ids[count.index] : var.image
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
  count    = var.volume_size > 0 ? var.nodes : 0
  name     = "${random_pet.name[count.index].id}-vl"     
  size     = var.volume_size
  location = var.location
}

resource "hcloud_volume_attachment" "attachment" {
  count     = var.volume_size > 0 ? var.nodes : 0
  server_id = hcloud_server.server[count.index].id
  volume_id = hcloud_volume.storage[count.index].id
}

resource "null_resource" "snapshot_before_destroy" {
  count = var.nodes

  triggers = {
    server_id   = hcloud_server.server[count.index].id
    server_name = hcloud_server.server[count.index].name
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      hcloud server create-image "${self.triggers.server_id}" \
        --description "vm-snapshot-${self.triggers.server_name}" \
        --type snapshot
    EOT
  }
}