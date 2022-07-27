require 'shrine'
require 'shrine/storage/s3'

Shrine.plugin :activerecord
Shrine.plugin :validation_helpers

Shrine.plugin :presign_endpoint, presign_options: lambda { |request|
  filename = request.params['filename']
  type     = request.params['type'] || 'application/octet-stream'

  {
    content_disposition: ContentDisposition.inline(filename), # set download filename
    content_type: type, # set content type (required if using DigitalOcean Spaces)
    content_length_range: 0..(5 * 1024 * 1024) # limit upload size to 10 Mb
  }
}

s3_options = {
  bucket: ENV.fetch('S3_BUCKET'),
  access_key_id: ENV.fetch('S3_KEY_ID'),
  secret_access_key: ENV.fetch('S3_SECRET_KEY'),
  region: ENV.fetch('S3_REGION'),
  endpoint: ENV.fetch('S3_ENDPOINT'),
  force_path_style: ENV['MINIO_FOR_S3'] == 'true'
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
  store: Shrine::Storage::S3.new(prefix: 'store', **s3_options)
}
