
variable "vm_management" {
  default = "manual"
}

variable "vm_count" {
  default = 3
}

variable "base_security_group_id" {}

variable "az" {
  type    = list(any)
  default = ["ru-central1-a", "ru-central1-b"]
}

variable "ssh_key" {}

variable "personal_zone" {
  type    = string
  default = "ru-central1-c"
}

variable "win_zone" {
  type    = string
  default = "ru-central1-b"
}

variable "sa_name" {
  default = "vmmanager"
}

variable "image_id" {
  type        = string
  description = "Image ID"
  validation {
    condition     = length(var.image_id) > 0
    error_message = "Paramter image_id сan't be empty."
  }
}
