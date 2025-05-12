resource hcloud_ssh_key "ssh_key" {
  name  = var.ssh_key_name
  public_key = file("${var.ssh_key_path}") 
}                                   