require 'shrine'
require 'shrine/storage/s3'

Shrine.plugin :activerecord
Shrine.plugin :validation_helpers

Shrine.plugin :presign_endpoint, presign_options: lambda { |request|
  filename = request.params['filename']
  type     = request.params['type']

  {
    content_disposition: ContentDisposition.inline(filename), # set download filename
    content_type: type, # set content type (required if using DigitalOcean Spaces)
    content_length_range: 0..(5 * 1024 * 1024), # limit upload size to 10 Mb
  }
}

s3_options = {
  bucket: ENV['S3_BUCKET'],
  access_key_id: ENV['S3_KEY_ID'],
  secret_access_key: ENV['S3_SECRET_KEY'],
  region: ENV['S3_REGION'],
  endpoint: ENV['S3_ENDPOINT'],
  force_path_style: true # This will be important for minio to work
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
  store: Shrine::Storage::S3.new(**s3_options)
}
