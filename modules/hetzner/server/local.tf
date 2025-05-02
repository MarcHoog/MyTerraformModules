locals {
  all_ssh_keys = concat(
    var.ssh_keys,
    var.ssh_key_path != "" ? [ hcloud_ssh_key.ssh_key[0].id ] : []          
  )
}