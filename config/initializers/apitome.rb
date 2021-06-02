Apitome.setup do |config|
  config.mount_at = "/api/docs"
  config.root = nil
  config.doc_path = "doc/api"
  config.title = "API Documentation"
  config.readme = "../api.md"
end
