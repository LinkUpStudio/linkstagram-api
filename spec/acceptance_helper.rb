require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = [:json]
  config.curl_host = 'http://localhost:3000'
  config.api_name = "Linkstagram API"

  config.define_group :linkstagram do |config|
    config.docs_dir = Rails.root.join("public", "assets", "api", "linkstagram")
    config.filter = :linkstagram
  end
end
