# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'support/helpers'
require 'support/database_cleaner'

# FIXME: temporary monkey-patched solution, more details here:
#   https://github.com/zipmark/rspec_api_documentation/issues/456
module RspecApiDocumentation
  class RackTestClient < ClientBase
    def response_body
      last_response.body.encode('utf-8')
    end
  end
end

RspecApiDocumentation.configure do |config|
  config.format = [:html, :json]
  config.request_body_formatter = proc do |params|
    JSON.pretty_generate(params)
  end
  config.response_body_formatter = proc do |response_content_type, response_body|
    JSON.pretty_generate(response_content_type)
    response_body
  end
  config.request_headers_to_include = %w[Content-Type Accept]
  config.response_headers_to_include = %w[Content-Type]

  config.curl_host = 'http://localhost:3000'
  config.api_name = 'Linkstagram API'
end
