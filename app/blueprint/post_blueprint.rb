class PostBlueprint < Blueprinter::Base
  identifier :id

  fields :description, :likes_count, :created_at
  association :author, blueprint: AccountBlueprint
  association :photos, blueprint: PhotoBlueprint
end
