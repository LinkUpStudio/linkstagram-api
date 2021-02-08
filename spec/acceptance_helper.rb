require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = [:api_blueprint]
  config.request_body_formatter = :json
  config.request_headers_to_include = %w[Content-Type Accept]
  config.response_headers_to_include = %w[Content-Type]

  config.curl_host = 'http://localhost:3000'
  config.api_name = "Linkstagram API"

  # config.define_group :linkstagram do |config|
  #   config.docs_dir = Rails.root.join("public", "assets", "api", "linkstagram")
  #   config.filter = :linkstagram
  # end
end
