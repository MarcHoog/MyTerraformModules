
locals {
  snapshot_ids = jsondecode(data.local_file.snapshot_ids.content)
}