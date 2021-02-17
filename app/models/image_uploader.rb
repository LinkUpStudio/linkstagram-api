class ImageUploader < Shrine
  Attacher.validate do
    validate_max_size 5.megabyte, message: 'is too large (max is 5 MB)'
      validate_mime_type_inclusion ['image/jpg', 'image/jpeg', 'image/png']
  end
end
