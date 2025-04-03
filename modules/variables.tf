variable "server_name" {
  description = "Name of the Hetzner server"
  type        = string
}

variable "image" {
  description = "The image slug to use for the server (e.g., ubuntu-22.04)"
  type        = string
}

variable "server_type" {
  description = "The type of the server (e.g., cx31)"
  type        = string
}

variable "location" {
  description = "Hetzner location (e.g., nbg1, fsn1)"
  type        = string
}

variable "ssh_keys" {
  description = "List of SSH key names (as registered in Hetzner) to add to the server"
  type        = list(string)
}

variable "volume_name" {
  description = "Name of the volume for storage"
  type        = string
}

variable "volume_size" {
  description = "Size of the volume in GB"
  type        = number
}

variable "firewall_name" {
  description = "Name for the firewall"
  type        = string
}

variable "firewall_description" {
  description = "Description for the firewall"
  type        = string
  default     = "Firewall for server and storage module"
}

variable "firewall_in_protocol" {
  description = "Protocol for the inbound firewall rule"
  type        = string
  default     = "tcp"
}

variable "firewall_in_port" {
  description = "Port for the inbound firewall rule (e.g., 80 or 443)"
  type        = string
  default     = "80"
}

variable "firewall_in_source_ips" {
  description = "List of source CIDR blocks for the inbound firewall rule"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
