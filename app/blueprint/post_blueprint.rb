class PostBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    fields :description, :likes_count, :created_at
  end

  view :with_author do
    include_view :normal
    association :author, blueprint: AccountBlueprint, view: :normal
  end
end
