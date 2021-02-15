class AccountBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    fields :username, :description, :profile_photo, :followers,
           :following
  end

  view :private do
    include_view :normal
    fields :email
  end

  view :with_posts do
    include_view :normal
    association :posts, blueprint: PostBlueprint, view: :normal
  end
end

# gem bullet
# make profiles get one account with their posts
# in blueprint post + its author
