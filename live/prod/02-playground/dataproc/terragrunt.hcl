
terraform {
  source = "../../../../tf-modules///ycloud-dataproc"
}

include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = find_in_parent_folders("common.hcl")
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "s3" {
  config_path = "../s3"
}

inputs = {
  dataproc_with_personal = true
  ssh_key                = file("../id_rsa.pub")
  s3_secret_key          = "${dependency.s3.outputs.s3_secret_key}"
  s3_access_key          = "${dependency.s3.outputs.s3_access_key}"
  network_id             = "${dependency.vpc.outputs.network_id}"
  subnets                = "${dependency.vpc.outputs.vpc_subnets_with_nat_network}"
  base_security_group_id = "${dependency.vpc.outputs.security_group_id}"
}
