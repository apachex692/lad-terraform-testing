run "setup_tests" {
  module {
    source = "./tests/setup/"
  }
}

run "create_bucket" {
  command = apply

  variables {
    bucket_name = "${run.setup_tests.bucket_prefix}-aws-s3-website-test"
  }

  assert {
    condition     = aws_s3_bucket.s3_bucket.bucket == "${run.setup_tests.bucket_prefix}-aws-s3-website-test"
    error_message = "Bucket name assertion failed."
  }

  assert {
    condition     = aws_s3_object.index.etag == filemd5("./www/index.html")
    error_message = "Invalid eTag for index.html."
  }

  assert {
    condition     = aws_s3_object.error.etag == filemd5("./www/error.html")
    error_message = "Invalid eTag for error.html."
  }
}

run "website_is_running" {
  command = plan

  module {
    source = "./tests/final"
  }

  variables {
    endpoint_url = run.create_bucket.website_endpoint
  }

  assert {
    condition     = data.http.index.status_code == 200
    error_message = "Website responded with HTTP status code ${data.http.index.status_code}."
  }
}
