module Helpers
  module JwtToken
    def jwt_token(id)
      rodauth = Rodauth::Rails.rodauth
      token = JWT.encode({ account_id: id },
                         rodauth.jwt_secret,
                         rodauth.jwt_algorithm)
      "Bearer #{token}"
    end
  end

  module JsonParse
    def parsed_json
      JSON.parse(response_body)
    end
  end

  module TestData
    module_function

    def image_data
      attacher = Shrine::Attacher.new
      attacher.set(uploaded_image)

      attacher.column_data # or attacher.data in case of postgres jsonb column
    end

    def uploaded_image
      file = File.open("spec/files/image.jpg", binmode: true)

      # for performance we skip metadata extraction and assign test metadata
      uploaded_file = ImageUploader.upload(file, :store, metadata: false)
      uploaded_file.metadata.merge!(
        "size"      => File.size(file.path),
        "mime_type" => "image/jpeg",
        "filename"  => "test.jpg",
      )

      uploaded_file
    end
  end
end
