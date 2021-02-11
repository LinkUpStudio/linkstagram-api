require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'support/helpers'
require 'support/database_cleaner'

RspecApiDocumentation.configure do |config|
  config.format = [:html]
  config.request_body_formatter = proc do |params|
    JSON.pretty_generate(params)
  end
  config.response_body_formatter = Proc.new { |response_content_type, response_body| response_body }
  config.request_headers_to_include = %w[Content-Type Accept]
  config.response_headers_to_include = %w[Content-Type]

  config.curl_host = 'http://localhost:3000'
  config.api_name = "Linkstagram API"
end
