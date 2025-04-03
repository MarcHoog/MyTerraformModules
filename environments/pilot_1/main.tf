module "hetzner_server_storage_firewall" {
  source        = "../../modules/hetzner_server_storage_firewall"
  server_name   = "pilot-server-prod"
  image         = "ubuntu-22.04"         # Use a valid image slug for Hetzner Cloud
  server_type   = "cx31"
  location      = "nbg1"                 # Example location; adjust as needed
  ssh_keys      = ["my-ssh-key"]         # Replace with your registered SSH key names

  volume_name   = "pilot-volume"
  volume_size   = 20                     # Volume size in GB

  firewall_name = "pilot-firewall"
  firewall_description = "Firewall for pilot Hetzner project"
  firewall_in_protocol  = "tcp"
  firewall_in_port      = "80"
  firewall_in_source_ips = ["0.0.0.0/0"]
}
