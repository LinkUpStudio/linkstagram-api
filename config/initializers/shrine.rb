require 'shrine'
require 'shrine/storage/file_system'

Shrine.plugin :activerecord
Shrine.plugin :validation_helpers

Shrine.plugin :presign_endpoint, presign_options: lambda { |request|
  filename = request.params['filename']
  type     = request.params['type']

  {
    content_disposition: ContentDisposition.inline(filename), # set download filename
    content_type: type, # set content type (required if using DigitalOcean Spaces)
    content_length_range: 0..(5 * 1024 * 1024),                   # limit upload size to 10 Mb
  }
}
