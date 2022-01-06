
resource "yandex_storage_bucket" "external_with_grant" {
  force_destroy = false
  bucket        = "${var.external_bucket_prefix}-with-grant"
  access_key    = yandex_iam_service_account_static_access_key.self.access_key
  secret_key    = yandex_iam_service_account_static_access_key.self.secret_key

  // same as public-read
  grant {
    type        = "Group"
    permissions = ["READ"]
    uri         = "http://acs.amazonaws.com/groups/global/AllUsers"
  }

  // Specific user (sspigelly@yandex.ru)
  //  grant {
  //    id          = <ID>
  //    type        = "CanonicalUser"
  //    permissions = ["FULL_CONTROL"]
  //  }

  // Specific user (SA)
  grant {
    id          = yandex_iam_service_account.uploader_without_binding.id
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }

  grant {
    type        = "Group"
    permissions = ["READ"]
    uri         = "http://acs.amazonaws.com/groups/global/AllUsers"
  }

  website {
    index_document = "index.html"
  }
}

resource "yandex_storage_object" "cute_cat_picture" {
  access_key = yandex_iam_service_account_static_access_key.self.access_key
  secret_key = yandex_iam_service_account_static_access_key.self.secret_key
  bucket     = yandex_storage_bucket.external_with_grant.bucket
  key        = "index.html"
  source     = "files/index.html"
}

resource "yandex_storage_bucket" "external_with_acl" {
  bucket     = "${var.external_bucket_prefix}-with-acl"
  access_key = yandex_iam_service_account_static_access_key.self.access_key
  secret_key = yandex_iam_service_account_static_access_key.self.secret_key

  // predefined
  acl = "public-read"


  website {
    redirect_all_requests_to = "https://${yandex_storage_bucket.external_with_grant.bucket}.website.yandexcloud.net"
  }
}

resource "yandex_storage_bucket" "external_with_policy" {
  force_destroy = false
  bucket        = "${var.external_bucket_prefix}-with-policy"
  access_key    = yandex_iam_service_account_static_access_key.self.access_key
  secret_key    = yandex_iam_service_account_static_access_key.self.secret_key

  //Since there is default IAM acl (private) it doesn't work!

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::${var.external_bucket_prefix}-with-policy/*",
        "arn:aws:s3:::${var.external_bucket_prefix}-with-policy"
      ]
    }
  ]
}
POLICY

}
