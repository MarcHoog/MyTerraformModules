output "name" {
  description = "The name of the created Hetzner SSH key"
  value = hcloud_ssh_key.ssh_key.name                
}