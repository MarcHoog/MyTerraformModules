# Hehe if this works it's kinda genius not gonna lie
resource "null_resource" "get_snapshots" {
  provisioner "local-exec" {
    command = <<EOT
      mkdir -p tmp
      echo "[" > tmp/snapshots.json
      for name in $(terraform output -raw random_names); do
        id=$(hcloud image list --selector type=snapshot --output json | jq -r ".[] | select(.description == \\"vm-snapshot-$name\\") | .id")
        echo "  \"$id\"," >> tmp/snapshots.json
      done
      echo "]" >> tmp/snapshots.json
    EOT
  }

  triggers = {
    always_run = timestamp()
  }
}

resource "random_pet" "name" {
  count     = var.nodes
  length    = 2    # e.g. “fluffy-sheep”
  separator = "-"
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
      hcloud server create-image "$SERVER_ID" \
        --description "vm-snapshot-$SERVER_NAME" \
        --type snapshot
    EOT
  }

  depends_on = [hcloud_server.server]
}