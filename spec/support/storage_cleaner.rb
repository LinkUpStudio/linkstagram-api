if ENV['S3_ENDPOINT'].include?('localhost')
  RSpec.configure do |config|
    config.before(:all) do
      Shrine.storages[:store].bucket.create unless Shrine.storages[:store].bucket.exists?
    end
    config.after(:all) do
      Shrine.storages[:cache].clear!
      Shrine.storages[:store].clear!
    end
  end
end
