class PostBlueprint < Blueprinter::Base
  identifier :id

  fields :description, :likes_count, :created_at
  field :is_liked do |post, options|
    post.liked_by?(options[:user])
  end

  association :author, blueprint: AccountBlueprint
  association :photos, blueprint: PhotoBlueprint
end
