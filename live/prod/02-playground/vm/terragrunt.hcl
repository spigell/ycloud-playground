

include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = find_in_parent_folders("common.hcl")
}

terraform {
  source = "../../../../tf-modules///ycloud-compute"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vm_management          = "group"
  image_id               = "fd8cvgkbamhii045e8rm"
  ssh_key                = file("../id_rsa.pub")
  network_id             = "${dependency.vpc.outputs.network_id}"
  subnets                = "${dependency.vpc.outputs.vpc_subnets}"
  base_security_group_id = "${dependency.vpc.outputs.security_group_id}"
}
