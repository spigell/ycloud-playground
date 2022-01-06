
variable "k8s_name" {
  default = "main"
}

variable "k8s_version" {
  default = "1.21"
}

variable "base_security_group_id" {}

variable "k8s_cluster_ipv4_range" {
  default = "10.112.0.0/16"
}

variable "k8s_service_ipv4_range" {
  default = "10.113.0.0/16"
}

variable "k8s_container_runtime_type" {
  default = "containerd"
}
