variable "region" {
  type    = string
  default ="us-east-1"
}
variable "profile" {
  default = "default"
}
variable "bucket_name"{
  default = "example-sinem"
}
variable "role_name"{
  default ="S3-ROLE"
}
variable "policy_name" {
  default = "test_policy"
}
variable "attachment"{
  default ="test_attachment"
}
