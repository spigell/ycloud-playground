
include "common" {
  path = find_in_parent_folders("common.hcl")
}

terraform {
  source = "../../../../tf-modules/ycloud-k8s"
}

inputs = {}
