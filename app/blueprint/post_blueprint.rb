class PostBlueprint < Blueprinter::Base
  identifier :id

  fields :description, :likes_count, :created_at
  association :author, blueprint: AccountBlueprint
end
