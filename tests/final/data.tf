data "http" "index" {
    url = var.endpoint_url
    method = "GET"
}
