
include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path = find_in_parent_folders("common.hcl")
}

terraform {
  source = "../../../../tf-modules///ycloud-s3"
}

inputs = {
  external_bucket_prefix = "schukh-bucket-test"
}
