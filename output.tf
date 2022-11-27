output "s3_bucket_endpoint"{
  description = "url for s3 bucket"
  value       = "${aws_s3_bucket.example.bucket_domain_name}"
}

output "first_object_endpoint" {
  description = "url for first object"
  value       = "${aws_s3_bucket.example.bucket_domain_name}${aws_s3_object.examplebucket_object.id}"
}

output "second_object_endpoint"{
  description = "url for second object"
  value       = "${aws_s3_bucket.example.bucket_domain_name}${aws_s3_object.examplebucket.id}"
}