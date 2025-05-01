variable "server_name" {
  description = "Name of the Hetzner server"
  type        = string
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
}

variable "ssh_keys" {
  description = "List of SSH key names (as registered in Hetzner) to add to the server"
  type        = list(string)
  default    = []
}

variable "volume_name" {
  description = "Name of the volume for storage"
  type        = string
  default     = ""
}

variable "volume_size" {
  description = "Size of the volume in GB"
  type        = number
  default     = 0
}
