

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "allow_read_access" {
  bucket = aws_s3_bucket.example.id
  policy = "${file("s3bucketpolicy.json")}"
}

/**
data "aws_canonical_user_id" "current" {}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.example.id
  access_control_policy {
    grant {
      grantee {
        id   = data.aws_canonical_user_id.current.id
        type = "CanonicalUser"
      }
      permission = "READ"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/global/AllUsers"
      }
      permission = "READ_ACP"
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}
**/
# if you want to give bucket read acces but no object acces
# you can use this block.



resource "aws_iam_role" "s3_access_role" {
  name               = var.role_name
  assume_role_policy = "${file("iamrole.json")}"
}


resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  description = "A test policy"
  policy      = "${file("iampolicy.json")}"
}


resource "aws_iam_policy_attachment" "test-attach" {
  name       = var.attachment
  roles      = ["${aws_iam_role.s3_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
} 



resource "aws_s3_object" "examplebucket_object" {

  key    = "/sinem.txt"
  bucket = aws_s3_bucket.example.id
  source = "sinem.txt"
  content_type  = "text/html"
  #acl = "public-read" # if we want to make read permission only for some objetc in the bucket we can use inline acl

}

resource "aws_s3_object" "examplebucket" {

  key    = "/cat.png"
  bucket = aws_s3_bucket.example.id
  source = "cat.png"
  content_type  = "image/png"
  /*** content_type
    html        = "text/html",
    js          = "application/javascript",
    css         = "text/css",
    svg         = "image/svg+xml",
    jpg         = "image/jpeg",
    ico         = "image/x-icon",
    png         = "image/png",
    gif         = "image/gif",
    pdf         = "application/pdf"
  } **/

}



