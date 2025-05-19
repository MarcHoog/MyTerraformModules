variable "server_names" {
  description = "Name of the Hetzner server"
  type        = list(string)
  default     = []

  validation {
    condition = length(var.server_names) != var.nodes
    error_message = "server_names must contain exactly entries."
  }

}

variable "nodes" {
  description = "Number of nodes to create"
  type        = number
  default     = 1             

  validation {
    condition     = var.nodes > 0
    error_message = "The number of nodes must be greater than 0"
  }                 
  
}

variable "image" {
  description = "The image slug to use for the server (e.g., ubuntu-22.04)"
  type        = string
  validation {
    condition     = contains(["ubuntu-22.04", "ubuntu-20.04", "ubuntu-24.04"], var.image)
    error_message = "The image must be one of: ubuntu-22.04, ubuntu-20.04, ubuntu-24.04"
  }
}

variable "server_type" {
  description = "The type of the server (e.g., cx31)"
  type        = string
}

variable "location" {
  description = "Hetzner location (e.g., nbg1, fsn1)"
  type        = string
  validation {
    condition     = contains(["nbg1", "fsn1"], var.location)
    error_message = "The location must be one of: nbg1, fsn1"
  }             
}

variable "ssh_keys" {
  description = "List of SSH key names (as registered in Hetzner) to add to the server"
  type        = list(string)
  default    = []
}

variable "volume_size" {
  description = "Size of the volume in GB"
  type        = number
  default     = 0
}


variable "ipv4_enabled" {
  description = "Enable IPv4 for the server(s)"
  type        = bool
  default     = false
}

variable "ipv6_enabled" {
  description = "Enable IPv6 for the server(s)"
  type        = bool
  default     = false               
  
}