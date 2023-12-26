output "website_endpoint" {
  description = "Website Endpoint URL"
  value       = "http://${aws_s3_bucket_website_configuration.s3_bucket.website_endpoint}/index.html"
}
